package com.zira.registration;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Random;

import org.apache.http.ParseException;

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
import android.widget.EditText;
import android.widget.ImageView;

import com.twentyfourseven.zira.R;
import com.zira.modal.ProfileInfoModel;
import com.zira.util.ExifUtils;
import com.zira.util.Util;
import com.zira.util.ZiraParser;

public class UploadBasicInfo extends Activity {
	ImageView rider_img, btn_cancel;
	ImageView btn_next;
	EditText edit_fisrtname, edit_LastName;
	Bitmap bitmap;
	String encodedImage = "", mCurrentPhotoPath;
	SharedPreferences reg_prefs;
	static String str_base64 = "";
	private Uri selectedImageUri;
	String lineEnd = "\r\n";
	String twoHyphens = "--";
	String boundary = "AaB03x87yxdkjnxvi7";
	private ZiraParser parser;
	private ArrayList<ProfileInfoModel> arraylistprof=new ArrayList<ProfileInfoModel>();
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.rider_register_two);
		intializevariables();
		clickListner();

		reg_prefs = getSharedPreferences("reg_Zira", MODE_PRIVATE);

		/*
		 * encodedImage = prefs.getString("userimage", "");
		 * edit_fisrtname.setText(prefs.getString("firstname", ""));
		 * edit_LastName.setText(prefs.getString("lastname", ""));
		 * 
		 * if(!encodedImage.equals("")){ byte[] decodedString =
		 * Base64.decode(encodedImage.trim(),Base64.DEFAULT); Bitmap decodedByte
		 * = BitmapFactory.decodeByteArray( decodedString, 0,
		 * decodedString.length);
		 * 
		 * //setting the decodedByte to ImageView
		 * rider_img.setImageBitmap(decodedByte); }
		 */
	}

	private void intializevariables() {
		parser=new ZiraParser();
		edit_fisrtname = (EditText) findViewById(R.id.editText_riderFirstName);
		edit_LastName = (EditText) findViewById(R.id.editText_riderLastName);
		rider_img = (ImageView) findViewById(R.id.imageView_rider_uploadImage);
		btn_next = (ImageView) findViewById(R.id.button_rider_Next_registwo);
		btn_cancel = (ImageView) findViewById(R.id.button_rider_back_registwo);
	}

	private void clickListner() {
		rider_img.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				selectImage();
			}
		});
		btn_next.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Util.hideKeyboard(UploadBasicInfo.this);
				String gettingFirstName = edit_fisrtname.getText().toString();
				String gettingSecondName = edit_LastName.getText().toString();
				if (gettingFirstName.equals("")) {
					Util.alertMessage(UploadBasicInfo.this,
							"Please enter first name.");
				} else if (gettingSecondName.equals("")) {

					Util.alertMessage(UploadBasicInfo.this,
							"Please enter last name.");
				} else if (encodedImage.equals("")) {
					Util.alertMessage(UploadBasicInfo.this,
							"Please upload profile image.");
				}

				else {
					
					new uploadimage().execute();
				}
			}
		});
		btn_cancel.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {

				finish();
			}
		});
	}

	protected void selectImage() {

		final CharSequence[] options = { "Take Photo", "Choose from Gallery",
				"Cancel" };

		AlertDialog.Builder builder = new AlertDialog.Builder(
				UploadBasicInfo.this);
		builder.setTitle("Add Photo!");
		builder.setItems(options, new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int item) {
				if (options[item].equals("Take Photo")) {
					Intent takePictureIntent = new Intent(
							MediaStore.ACTION_IMAGE_CAPTURE);
					// Ensure that there's a camera activity to handle the
					// intent
					if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
						// Create the File where the photo should go
						File photoFile = null;
						try {
							mCurrentPhotoPath = Util.createImageFile();
							photoFile = new File(mCurrentPhotoPath);
						} catch (Exception ex) {
							// Error occurred while creating the File
							ex.printStackTrace();
						}
						// Continue only if the File was successfully created
						if (photoFile != null) {
							takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT,
									Uri.fromFile(photoFile));
							startActivityForResult(takePictureIntent, 1);
						}
					}
				} else if (options[item].equals("Choose from Gallery")) {
					Intent intent = new Intent();
					intent.setType("image/*");
					intent.setAction(Intent.ACTION_GET_CONTENT);
					startActivityForResult(
							Intent.createChooser(intent, "Select Picture"), 2);
				} else if (options[item].equals("Cancel")) {
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
				encodedImage = "";
				imagePath = mCurrentPhotoPath;
				
				Bitmap bitmap=BitmapFactory.decodeFile(mCurrentPhotoPath);  
				Bitmap bm2=ExifUtils.rotateBitmap(mCurrentPhotoPath, bitmap);
					
				rider_img.setImageBitmap(bm2);
				imagePath=SaveImage(bm2);
				
			} else if (requestCode == 2) {
				encodedImage = "";
				Uri selectedImageUri = data.getData();

				Cursor cursor = getContentResolver()
						.query(selectedImageUri,
								new String[] { android.provider.MediaStore.Images.ImageColumns.DATA },
								null, null, null);
				cursor.moveToFirst();

				// Link to the image
				final String imageFilePath = cursor.getString(0);
				cursor.close();
				imagePath = imageFilePath;
				
				Bitmap bitmap=BitmapFactory.decodeFile(imagePath);  
				Bitmap bm2=ExifUtils.rotateBitmap(imagePath, bitmap);
					
				rider_img.setImageBitmap(bm2);
				imagePath=SaveImage(bm2);
			}

			Util.showImage(imagePath, rider_img);

			encodedImage = imagePath;
			//System.err.println("encodedImage==" + encodedImage);
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
			pDialog = new ProgressDialog(UploadBasicInfo.this);

			// pDialog.setTitle("Loading");
			pDialog.setMessage("Please wait...");
			pDialog.setCancelable(false);
			pDialog.show();
		}

		@Override
		protected Void doInBackground(Void... arg0) {

			try {
				// String
				// res=uploadFile2Server("http://service.zira247.com/ZiraMobileService.svc/ImageUpload",
				// imagePath);
				 res = multipartRequest(
						 "http://service.zira247.com/ZiraMobileService.svc/ImageUpload",
						encodedImage);
				Log.e("", "resres" + res);
				
				// uploadFile1(imagePath);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);
			arraylistprof=parser.getimageUrl(res);
			Editor e = reg_prefs.edit();
			e.putString("userimage", arraylistprof.get(0).getImage());
			e.putString("firstname", edit_fisrtname.getText().toString());
			e.putString("lastname", edit_LastName.getText().toString());
			e.commit();

			pDialog.dismiss();
			Intent i = new Intent(UploadBasicInfo.this,	AddCreditInfo.class);
			startActivity(i);
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

			// Upload POST Data
			//String[] posts = post.split("&");
			// int max = posts.length;
			// for(int i=0; i<max;i++) {
			// outputStream.writeBytes(twoHyphens + boundary + lineEnd);
			// String[] kv = posts[i].split("=");
			// outputStream.writeBytes("Content-Disposition: form-data; name=\""
			// + kv[0] + "\"" + lineEnd);
			// outputStream.writeBytes("Content-Type: text/plain"+lineEnd);
			// outputStream.writeBytes(lineEnd);
			// outputStream.writeBytes(kv[1]);
			// outputStream.writeBytes(lineEnd);
			// }

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
	private String SaveImage(Bitmap finalBitmap) {

	    String root = Environment.getExternalStorageDirectory().toString();
	    File myDir = new File(root + "/saved_images");    
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
	    }
	    return file.getAbsolutePath();
	}
}
