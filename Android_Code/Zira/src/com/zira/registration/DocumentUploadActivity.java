package com.zira.registration;


import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.Random;

import org.apache.http.NameValuePair;
import org.apache.http.ParseException;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ImageView;

import com.twentyfourseven.zira.R;
import com.zira.async_tasks.AsyncResponseForZira;
import com.zira.async_tasks.AsyncTaskForZira;
import com.zira.modal.ProfileInfoModel;
import com.zira.profile.GetProfile;
import com.zira.util.ExifUtils;
import com.zira.util.ImageLoader;
import com.zira.util.SingleTon;
import com.zira.util.Util;
import com.zira.util.ZiraParser;
//import android.provider.DocumentsContract;


public class DocumentUploadActivity extends Activity implements OnClickListener,AsyncResponseForZira {

	private ImageLoader imageLoader;
	private ProfileInfoModel mProfileInfoModel;
	private ImageView vehicleImage,RCImage,licenceImage,medicalImage;
	private Button done;
	private Bitmap bitmap;
	private String trigger="";	
	private String driverRegMethod ="DriverRegistration", uploadImageMethod = "UploadImage", mCurrentPhotoPath, encodedImage;
	private SharedPreferences prefs;
	Editor editor;
	SharedPreferences prefs3;
	private String GetProfile="GetProfiles";
	private ZiraParser ziraParser;
	private CheckBox checkbox_confirm;
	private ZiraParser parser;
	private ArrayList<ProfileInfoModel> arraylistprof=new ArrayList<ProfileInfoModel>();
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.activity_document_upload);
	try{
		
		VehicleInformationActivity.regActivities.add(DocumentUploadActivity.this);
		}
		catch(Exception e)
		{
			logFile("activity finish array",e);
			}
		prefs = getSharedPreferences("Zira", MODE_PRIVATE);
		
		initialiseVariable();
		initialiseListener();
	}

	private void initialiseListener() {

		vehicleImage.setOnClickListener(this);
		RCImage.setOnClickListener(this);
		licenceImage.setOnClickListener(this);
		medicalImage.setOnClickListener(this);
		done.setOnClickListener(this);
	}

	private void initialiseVariable() {
		
		ziraParser = new ZiraParser();
		//prefs3 = getSharedPreferences("Ziradata", MODE_PRIVATE);
		editor=prefs.edit();
		mProfileInfoModel=SingleTon.getInstance().getProfileInfoModel();
		vehicleImage=(ImageView)findViewById(R.id.vehicleImage);
		RCImage=(ImageView)findViewById(R.id.RCImage);
		licenceImage=(ImageView)findViewById(R.id.licenceImage);
		medicalImage=(ImageView)findViewById(R.id.medicalImage);
		done=(Button)findViewById(R.id.done);
		checkbox_confirm=(CheckBox)findViewById(R.id.checkBox_document);
		if(SingleTon.getInstance().isEdited()){
			
			imageLoader = new ImageLoader(DocumentUploadActivity.this);
			imageLoader.DisplayImage(mProfileInfoModel.getVechile_img_location(),vehicleImage);
	    	imageLoader.DisplayImage(mProfileInfoModel.getRc_img_location(),RCImage);
	    	imageLoader.DisplayImage(mProfileInfoModel.getLicense_img_location(),licenceImage);
	    	imageLoader.DisplayImage(mProfileInfoModel.getMedicalcertificate_img_location(),medicalImage);
		}
	}

	@Override
	public void onClick(View v) {

		switch (v.getId()) {

		case R.id.vehicleImage:
			trigger="vehicle";
			selectImage();
			break;

		case R.id.RCImage:
			trigger="rc";
			selectImage();

			break;

		case R.id.licenceImage:
			trigger="drivinglicense";
			selectImage();
			break;

		case R.id.medicalImage:
			trigger="medicalcertificate";
			selectImage();
			break;

		case R.id.done:
			if(checkbox_confirm.isChecked())
			{
				uploadDataToServer();
				}
			else
			{
				Util.alertMessage(DocumentUploadActivity.this, "Please select the Confirm message");
				}
			break;

		default:

			break;
		}
	}

	private void uploadDataToServer() {

		try {
			if(Util.isNetworkAvailable(DocumentUploadActivity.this)){
			ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(1);
			
			nameValuePairs.add(new BasicNameValuePair("riderid", prefs.getString("riderid", null)));
			nameValuePairs.add(new BasicNameValuePair("vehicle_make", SingleTon.getInstance().getVehicleMake()));
			nameValuePairs.add(new BasicNameValuePair("vehicle_model",  SingleTon.getInstance().getVehicleModel()));
			
			nameValuePairs.add(new BasicNameValuePair("vehicle_year",SingleTon.getInstance().getVehicleYear()));
			nameValuePairs.add(new BasicNameValuePair("licensePlateNumber", SingleTon.getInstance().getVehicleLicencePlateNumber()));
			nameValuePairs.add(new BasicNameValuePair("licensePlateCountry",SingleTon.getInstance().getVehicleCountryName()));
			
			nameValuePairs.add(new BasicNameValuePair("licensePlateState", SingleTon.getInstance().getVehicleStateName()));
			nameValuePairs.add(new BasicNameValuePair("address1",  SingleTon.getInstance().getBg_address1()));
			nameValuePairs.add(new BasicNameValuePair("address2",""));// SingleTon.getInstance().getBg_address2()));
			
			nameValuePairs.add(new BasicNameValuePair("city",SingleTon.getInstance().getBg_city()));
			nameValuePairs.add(new BasicNameValuePair("state", SingleTon.getInstance().getBg_drivingLicenseState()));
			nameValuePairs.add(new BasicNameValuePair("zipcode", SingleTon.getInstance().getBg_zipcode()));
			
			nameValuePairs.add(new BasicNameValuePair("drivingLicenseNumber", SingleTon.getInstance().getBg_drivingLicenseNumber()));
			nameValuePairs.add(new BasicNameValuePair("drivingLicenseState", SingleTon.getInstance().getBg_drivingLicenseState()));
			nameValuePairs.add(new BasicNameValuePair("drivingLicenseExpirationDate", SingleTon.getInstance().getBg_LicExoDate()));
			
			nameValuePairs.add(new BasicNameValuePair("dateofbirth", SingleTon.getInstance().getBgDOB()));
			nameValuePairs.add(new BasicNameValuePair("socialSecurityNumber", SingleTon.getInstance().getBg_socialSecNumber()));
			nameValuePairs.add(new BasicNameValuePair("vehicleImage", prefs.getString("vehicle", "")));
			
			nameValuePairs.add(new BasicNameValuePair("rcImage", prefs.getString("rc", "")));
			nameValuePairs.add(new BasicNameValuePair("licenseImage",prefs.getString("drivinglicense", "")));
			nameValuePairs.add(new BasicNameValuePair("medicalCertificateImage", prefs.getString("medicalcertificate", "")));
			//vehicle//rc//drivinglicense//medicalcertificate
			
			
			AsyncTaskForZira mRegister = new AsyncTaskForZira(DocumentUploadActivity.this, driverRegMethod,nameValuePairs, true, "Please wait...");
			mRegister.delegate = (AsyncResponseForZira) DocumentUploadActivity.this;
			mRegister.execute();

		}
		else
		{
			Util.alertMessage(DocumentUploadActivity.this, "Please check your internet connection");
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
			logFile("Driver register web call  ",e);
		
		} 
	}


	protected void selectImage() {

		final CharSequence[] options = { "Take Photo", "Choose from Gallery","Cancel" };

		AlertDialog.Builder builder = new AlertDialog.Builder(DocumentUploadActivity.this);
		builder.setTitle("Add Photo!");
		builder.setItems(options, new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int item) {
				if (options[item].equals("Take Photo"))
				{
					Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
					// Ensure that there's a camera activity to handle the intent
					if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
						// Create the File where the photo should go
						File photoFile = null;
						try {
							mCurrentPhotoPath = Util.createImageFile();
							photoFile = new File(mCurrentPhotoPath);
						} catch (Exception ex) {
							// Error occurred while creating the File
							ex.printStackTrace();
							logFile("camera image set   image view ",ex);//log file check
						}
						// Continue only if the File was successfully created
						if (photoFile != null) {
							takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT,
									Uri.fromFile(photoFile));
							startActivityForResult(takePictureIntent, 1);
						}
					}
				}
				else if (options[item].equals("Choose from Gallery"))
				{
					Intent intent = new Intent();
					intent.setType("image/*");
					intent.setAction(Intent.ACTION_GET_CONTENT);
					startActivityForResult(Intent.createChooser(intent, "Select Picture"), 2);
				}
				else if (options[item].equals("Cancel")) {
					dialog.dismiss();
				}
			}
		});
		builder.show();

	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode == RESULT_OK) {
			String imagePath = "";

			if (requestCode == 1) {
				
				try{
				encodedImage="";
				imagePath = mCurrentPhotoPath;
				
				
				//amrik code
				
				Bitmap bm1=BitmapFactory.decodeFile(imagePath);
				Bitmap bm2=ExifUtils.rotateBitmap(imagePath, bm1);
				if(trigger.equalsIgnoreCase("vehicle"))	
				{
					vehicleImage.setImageBitmap(bm2);
				}
				else if(trigger.equalsIgnoreCase("rc"))	
				{
					RCImage.setImageBitmap(bm2);
				}
				else if(trigger.equalsIgnoreCase("drivinglicense"))	
				{
					licenceImage.setImageBitmap(bm2);
				}
				else if(trigger.equalsIgnoreCase("medicalcertificate"))	
				{
					medicalImage.setImageBitmap(bm2);
				}
			
				imagePath=SaveImage(bm2);
			}
			catch(Exception e)
			{
				logFile("camera image set   image view ",e);//log file check
			}
			} else if (requestCode == 2) {
				encodedImage="";
				try{
				Uri selectedImageUri = data.getData();

				Cursor cursor = getContentResolver().query(selectedImageUri, new String[] { android.provider.MediaStore.Images.ImageColumns.DATA }, null, null, null);
				cursor.moveToFirst();

				//Link to the image
				final String imageFilePath = cursor.getString(0);
				cursor.close();
				imagePath = imageFilePath;	
				
				//amrik code
				Bitmap bm1=BitmapFactory.decodeFile(imagePath);
				Bitmap bm2=ExifUtils.rotateBitmap(imagePath, bm1);
				if(trigger.equalsIgnoreCase("vehicle"))	
				{
					vehicleImage.setImageBitmap(bm2);
				}
				else if(trigger.equalsIgnoreCase("rc"))	
				{
					RCImage.setImageBitmap(bm2);
				}
				else if(trigger.equalsIgnoreCase("drivinglicense"))	
				{
					licenceImage.setImageBitmap(bm2);
				}
				else if(trigger.equalsIgnoreCase("medicalcertificate"))	
				{
					medicalImage.setImageBitmap(bm2);
				}
				
				imagePath=SaveImage(bm2);
				}
				catch(Exception e)
				{
					logFile("gallary image set   image view ",e);//log file check
				}
			}

			if(trigger.equals("vehicle")){
				encodedImage =imagePath ;// Util.showImage(imagePath, vehicleImage);
			}
			else if(trigger.equals("rc")){
				encodedImage =imagePath;// Util.showImage(imagePath, RCImage);
			}
			else if(trigger.equals("drivinglicense")){
				encodedImage =imagePath;// Util.showImage(imagePath, licenceImage);
			}
			else if(trigger.equals("medicalcertificate")){
				encodedImage =imagePath;// Util.showImage(imagePath, medicalImage);
			}

			try {
				if(Util.isNetworkAvailable(DocumentUploadActivity.this)){
					
					new uploadimage().execute();
				
				//mUploadImage.execute();
				}
				else
				{
					Util.alertMessage(DocumentUploadActivity.this, "Please check your internet connection");
					}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				 logFile("uploadimage  save",e);//log file check
				}          	
		}
	}
	private class uploadimage extends AsyncTask<Void, Void, Void> { // Async_task
		// class
        String res;
		private ProgressDialog pDialog;

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			// Showing progress dialog
			pDialog = new ProgressDialog(DocumentUploadActivity.this);

			// pDialog.setTitle("Loading");
			pDialog.setMessage("Please wait...");
			pDialog.setCancelable(false);
			pDialog.show();
		}

		@Override
		protected Void doInBackground(Void... arg0) {

			try {
			
		//		Log.d("", "encodedImage" + encodedImage);
				
				 res = multipartRequest("http://service.zira247.com/ZiraMobileService.svc/ImageUpload",encodedImage);
				
				 Log.d("", "resres" + res);
				// uploadFile1(imagePath);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				 logFile("doInBackground   uploadImageMethod ",e);//log file check
			}

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);
			    arraylistprof=ziraParser.getimageUrl(res);
			  
			   try{
				   Log.d("","after load image name="+arraylistprof.get(0).getImage());
				   saveImageName(arraylistprof.get(0).getImage());
				
				   pDialog.dismiss();
				/*if(Util.isNetworkAvailable(DocumentUploadActivity.this)){
					
					ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
					
					nameValuePairs.add(new BasicNameValuePair("RiderId",  prefs.getString("riderid", prefs.getString("riderid", null))));
					nameValuePairs.add(new BasicNameValuePair("Trigger", trigger));
					nameValuePairs.add(new BasicNameValuePair("ImageName",arraylistprof.get(0).getImage() ));
		
					
					Log.e("IMAGEUPLOAD", nameValuePairs.toString());
					AsyncTaskForZira mUploadImage = new AsyncTaskForZira(DocumentUploadActivity.this, uploadImageMethod,nameValuePairs,false,"");
					mUploadImage.delegate = (AsyncResponseForZira) DocumentUploadActivity.this;
				    mUploadImage.execute();
				}
				else
				{
					Util.alertMessage(DocumentUploadActivity.this, "Please check your internet connection");
					}*/
			}
		
			catch(Exception e)
			{
				e.printStackTrace();
				 logFile("post   uploadImageMethod ",e);//log file check
			}
//			Editor e = reg_prefs.edit();
//			e.putString("userimage", arraylistprof.get(0).getImage());
//			e.putString("firstname", edit_fisrtname.getText().toString());
//			e.putString("lastname", edit_LastName.getText().toString());
//			e.commit();

			
			//Intent i = new Intent(UploadBasicInfo.this,	AddCreditInfo.class);
			//startActivity(i);
		}
	}
	
	public String multipartRequest(String urlTo, String filepath)
			throws ParseException, IOException {
		HttpURLConnection connection = null;
		DataOutputStream outputStream = null;
		InputStream inputStream = null;

		String twoHyphens = "--";
		String boundary = "*****" + Long.toString(System.currentTimeMillis())
				+ "*****";
		String lineEnd = "\r\n";

		String result = "";

		int bytesRead, bytesAvailable, bufferSize;
		byte[] buffer;
		int maxBufferSize = 1 * 1024 * 1024;

		String[] q = filepath.split("/");
		int idx = q.length - 1;

		try {
			File file = new File(filepath);
			FileInputStream fileInputStream = new FileInputStream(file);

			URL url = new URL(urlTo);
			connection = (HttpURLConnection) url.openConnection();

			connection.setDoInput(true);
			connection.setDoOutput(true);
			connection.setUseCaches(false);

			connection.setRequestMethod("POST");
			connection.setRequestProperty("Connection", "Keep-Alive");
			connection.setRequestProperty("User-Agent",
					"Android Multipart HTTP Client 1.0");
			connection.setRequestProperty("Content-Type",
					"multipart/form-data; boundary=" + boundary);

			outputStream = new DataOutputStream(connection.getOutputStream());
			outputStream.writeBytes(twoHyphens + boundary + lineEnd);
			outputStream
					.writeBytes("Content-Disposition: form-data;filename=\""
							+ q[idx] + "\"" + lineEnd);
			outputStream.writeBytes("Content-Type: image/jpeg" + lineEnd);
			outputStream.writeBytes("Content-Transfer-Encoding: binary"
					+ lineEnd);
			outputStream.writeBytes(lineEnd);

			bytesAvailable = fileInputStream.available();
			bufferSize = Math.min(bytesAvailable, maxBufferSize);
			buffer = new byte[bufferSize];

			bytesRead = fileInputStream.read(buffer, 0, bufferSize);
			while (bytesRead > 0) {
				outputStream.write(buffer, 0, bufferSize);
				bytesAvailable = fileInputStream.available();
				bufferSize = Math.min(bytesAvailable, maxBufferSize);
				bytesRead = fileInputStream.read(buffer, 0, bufferSize);
			}

			outputStream.writeBytes(lineEnd);

			outputStream.writeBytes(twoHyphens + boundary + twoHyphens
					+ lineEnd);

			inputStream = connection.getInputStream();
			result = this.convertStreamToString(inputStream);

			fileInputStream.close();
			inputStream.close();
			outputStream.flush();
			outputStream.close();

			return result;
		} catch (Exception e) {
			Log.e("MultipartRequest", "Multipart Form Upload Error");
			e.printStackTrace();
			return "error";
		}
	}

	private String convertStreamToString(InputStream is) {
		BufferedReader reader = new BufferedReader(new InputStreamReader(is));
		StringBuilder sb = new StringBuilder();

		String line = null;
		try {
			while ((line = reader.readLine()) != null) {
				sb.append(line);
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				is.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return sb.toString();
	}

	@Override
	public void processFinish(String output, String methodName) {
		// obj;
		Log.e("doucment", output);
		if(methodName.equalsIgnoreCase(uploadImageMethod))
		{
			Log.e("doucment1122", output);
			/*try {
				//JSONObject	obj = new JSONObject(output);
			//	String jsonMessage=obj.getString("message");
				//String jsonMessage1=obj.getString("result");
			//	System.err.println("messgage=="+jsonMessage+"result="+jsonMessage1);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}*/
		}
		if(methodName.equalsIgnoreCase(driverRegMethod))
		{
			Log.e("driver update", output);
			try {
				JSONObject obj = new JSONObject(output);
				String jsonResult=obj.getString("result");
				String jsonMessage=obj.getString("message");
				
				if(jsonResult.equals("0"))
				{
					//Util.alertMessage(DocumentUploadActivity.this, jsonMessage);
					//vehicle//rc//drivinglicense//medicalcertificate
					editor.putString("vehicle", "");
					editor.putString("rc", "");
					editor.putString("drivinglicense", "");
					editor.putString("medicalcertificate", "");
					editor.commit();
					
					AlertDialog.Builder alert = new AlertDialog.Builder(DocumentUploadActivity.this);
					alert.setTitle("Zira24/7");
					alert.setMessage("Registration successful");
				
					alert.setPositiveButton("ok", new DialogInterface.OnClickListener() {
						
						@Override
						public void onClick(DialogInterface arg0, int arg1) {
							//System.err.println("messgage=="+jsonMessage+" "+jsonResult);
							//				Toast.makeText(DocumentUploadActivity.this, jsonMessage, 1).show();
											SingleTon.getInstance().setEdited(false);		
											mProfileInfoModel.setVechile_make(SingleTon.getInstance().getVehicleMake());
											mProfileInfoModel.setVechile_model(SingleTon.getInstance().getVehicleModel());
											mProfileInfoModel.setVechile_year(SingleTon.getInstance().getVehicleYear());
											mProfileInfoModel.setLicenseplatenumber(SingleTon.getInstance().getVehicleLicencePlateNumber());
											mProfileInfoModel.setLicenseplatecountry(SingleTon.getInstance().getVehicleCountryName());
											mProfileInfoModel.setLicenseplatestate(SingleTon.getInstance().getVehicleStateName());
											mProfileInfoModel.setAddress(SingleTon.getInstance().getBg_address1()+"");
											mProfileInfoModel.setAddress1(SingleTon.getInstance().getBg_address1());
											mProfileInfoModel.setAddress2("");//SingleTon.getInstance().getBg_address2());
											mProfileInfoModel.setCity(SingleTon.getInstance().getBg_city());
											mProfileInfoModel.setState(SingleTon.getInstance().getBg_drivingLicenseState());
											mProfileInfoModel.setZipcode(SingleTon.getInstance().getBg_zipcode());
											mProfileInfoModel.setDrivinglicensenumber(SingleTon.getInstance().getBg_drivingLicenseNumber());
											mProfileInfoModel.setDrivinglicensestate(SingleTon.getInstance().getBg_drivingLicenseState());
											mProfileInfoModel.setDrivinglicenseexpirationdate(SingleTon.getInstance().getBg_LicExoDate());
											mProfileInfoModel.setDateofbirth(SingleTon.getInstance().getBgDOB());
											mProfileInfoModel.setSocialsecuritynumber(SingleTon.getInstance().getBg_socialSecNumber());
											SingleTon.getInstance().setProfileInfoModel(mProfileInfoModel);
											getProfileInfo();
											//finish();
						}
					});
					alert.show();
								
									
					}
				else
				{
					Util.alertMessage(DocumentUploadActivity.this, jsonMessage);		
					}

			
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			 logFile("driver register",e1);//log file check
		}
		}
		if(methodName.equalsIgnoreCase(GetProfile))
		{
			Log.e("getprofile=", output);
			mProfileInfoModel = ziraParser.profileInfo(output);
			SingleTon.getInstance().setProfileInfoModel(mProfileInfoModel);
			Intent intent=new Intent(DocumentUploadActivity.this,GetProfile.class);
			intent.putExtra("profile", mProfileInfoModel);
			startActivity(intent);
			finish();
		
		}
	}
	private void getProfileInfo() {
		if(Util.isNetworkAvailable(DocumentUploadActivity.this))
		{
		ArrayList<NameValuePair> nameValuePair = new ArrayList<NameValuePair>(1);
		nameValuePair.add(new BasicNameValuePair("UserId", prefs.getString("riderid", "")));
		AsyncTaskForZira mWebPageTask = new AsyncTaskForZira(DocumentUploadActivity.this, GetProfile,nameValuePair, true, "Please wait...");
		mWebPageTask.delegate = (AsyncResponseForZira) DocumentUploadActivity.this;mWebPageTask.execute();
		
		}else
		{
			Util.alertMessage(DocumentUploadActivity.this, "Please check your internet connection");
			}
		}
	
	@Override
	public void onBackPressed() {
		Intent intent = new Intent(DocumentUploadActivity.this,BackgroundCheckActivity.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
		startActivity(intent);
	}
	
	private String SaveImage(Bitmap finalBitmap) {

	    String root = Environment.getExternalStorageDirectory().toString();
	    File myDir = new File(root + "/Zira_images");    
	    myDir.mkdirs();
	    Random generator = new Random();
	    int n = 10000;
	    n = generator.nextInt(n);
	    String fname = "Image-"+ n +".jpg";
	    File file = new File (myDir, fname);
	    if (file.exists ()) file.delete (); 
	    try {
	           FileOutputStream out = new FileOutputStream(file);
	           finalBitmap.compress(Bitmap.CompressFormat.JPEG, 90, out);
	           out.flush();
	           out.close();

	    } catch (Exception e) {
	           e.printStackTrace();
	           logFile("bitmap  save",e);//log file check
	    }
	    return file.getAbsolutePath();
	}
	
	
	private void logFile(String str, Exception e)
	{
		File myFile = new File(Environment.getExternalStorageDirectory()+"/ziralogs.txt");
//		("/sdcard/ziralogs.txt");
	try
	{
		FileOutputStream fOut = new FileOutputStream(myFile, true);
		OutputStreamWriter myOutWriter = 
								new OutputStreamWriter(fOut);
		myOutWriter.append(File.separator);
		myOutWriter.append("/////////////DocumentUploadActivity///" + str +"///////////"+File.separator+File.separator+ String.valueOf(new Date()));
		
		String stackTrace = Log.getStackTraceString(e);
		myOutWriter.append(stackTrace);
		myOutWriter.close();
		fOut.close();
	}
	catch(Exception e1)
	{
		e1.printStackTrace();  
	}
	}
	private void saveImageName(String imageName)
	{
		//vehicle//rc//drivinglicense//medicalcertificate
		//Editor editor=prefs.edit();
		
		if(trigger.equals("vehicle")){
			editor.putString("vehicle", imageName);
			  Log.e("","save vehicle="+imageName);	
		}
		else if(trigger.equals("rc")){
			editor.putString("rc", imageName);
			  Log.e("","save rc="+imageName);	
			
		}
		else if(trigger.equals("drivinglicense")){
			editor.putString("drivinglicense", imageName);
			  Log.e("","save drivinglicense="+imageName);	
			
		}
		else if(trigger.equals("medicalcertificate")){
			editor.putString("medicalcertificate", imageName);
			 Log.e("","save medicalcertificate="+imageName);	
			
		}
		editor.commit();
		
		  Log.e("","after load image name="+imageName);	
	}
}
