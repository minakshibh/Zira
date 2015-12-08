package com.zira.profile;


import java.io.InputStream;
import java.util.ArrayList;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.twentyfourseven.zira.LoginActivity;
import com.twentyfourseven.zira.R;
import com.twentyfourseven.zira.VehicleSearchActivity;
import com.zira.async_tasks.AsyncResponseForZira;
import com.zira.async_tasks.AsyncTaskForZira;
import com.zira.modal.ProfileInfoModel;
import com.zira.registration.VehicleInformationActivity;
import com.zira.util.ImageLoader;
import com.zira.util.SingleTon;
import com.zira.util.Util;
import com.zira.util.ZiraParser;


public class GetProfile extends Activity implements OnClickListener,AsyncResponseForZira{
	
	private ImageView riderImg, driverImg;
	private Button btn_edit_rider, btn_edit_driver, btn_signOut;
	private TextView txt_ridername, txt_rideremail, txt_rider_mobilenumber,
			txt_vehicleCompanyName, txt_vehiclename, txtvehicleNumber,
			txt_zipCode, txt_lisenseNo, txt_socialSecurityNumber,textView_address;	
	private ProfileInfoModel mProfileInfoModel;
	private ImageLoader imageLoader;
	private RelativeLayout rel_vehicleinfo1;
	private LinearLayout lin_vehicleinfo2;
	private ImageView imageViewProfilepic;
	SharedPreferences prefs;
//	private ProfileInfoModel mprofileInfoModel;
	Editor e;
	Bitmap bm2;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {	
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.new_get_profile);
		
		
		intailizeVariable();
		clickListner();	
		prefs=getSharedPreferences("Zira", MODE_PRIVATE);
		e=prefs.edit();
	}
	
	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		try{
		mProfileInfoModel = (ProfileInfoModel)getIntent().getParcelableExtra("profile");
		//mProfileInfoModel = extras.getParcelable("profile");
		mProfileInfoModel.getFirstname();
		//mProfileInfoModel = SingleTon.getInstance().getProfileInfoModel();
		txt_ridername.setText(mProfileInfoModel.getFirstname());
		txt_rideremail.setText(mProfileInfoModel.getEmail());
		txt_rider_mobilenumber.setText(mProfileInfoModel.getMobile());
		txt_vehicleCompanyName.setText(mProfileInfoModel.getVechile_make());
		txt_vehiclename.setText(mProfileInfoModel.getVechile_model());
		textView_address.setText(mProfileInfoModel.getAddress());
		txtvehicleNumber.setText(mProfileInfoModel.getLicenseplatenumber());
		txt_zipCode.setText("Zip Code:"+" "+mProfileInfoModel.getZipcode());			
		txt_socialSecurityNumber.setText("Social no:"+" "+mProfileInfoModel.getSocialsecuritynumber());
		txt_lisenseNo.setText("Licence no:"+" "+mProfileInfoModel.getDrivinglicensenumber());		
		imageViewProfilepic=(ImageView)findViewById(R.id.imageViewProfilepic);
		imageLoader = new ImageLoader(GetProfile.this);
		 //new DownloadImageTask((ImageView)findViewById(R.id.imageViewProfilepic)).execute(mProfileInfoModel.getImage());
    	//imageLoader.DisplayImage(mProfileInfoModel.getImage(),riderImg );
		//Uri url = new Uri(mProfileInfoModel.getImage());
		// imageLoader = new ImageLoader(VehicleSearchActivity.this);
		imageLoader.DisplayImage(prefs.getString("userimage", ""), imageViewProfilepic);
		
		
		
    
    	
    	Log.e("prodile","image12222222ggg"+ mProfileInfoModel.getImage());
    	Log.e("prodile","image12222222gggg"+ mProfileInfoModel.getImage());
    	imageLoader.DisplayImage(mProfileInfoModel.getVechile_img_location(), driverImg);
    	
    	rel_vehicleinfo1=(RelativeLayout)findViewById(R.id.RelativeLayout_Vehicleinfo1);
    	lin_vehicleinfo2=(LinearLayout)findViewById(R.id.LinearLayout_vehicleLayout);
    	if(mProfileInfoModel.getAddress()==null)
    	{}
    	else
    	{
    	if(mProfileInfoModel.getAddress().equals(""))
    	{
    		rel_vehicleinfo1.setVisibility(View.INVISIBLE);
    		lin_vehicleinfo2.setVisibility(View.INVISIBLE);
    		
    	}
    	}
		}catch(Exception e){}
	}
	
	public void intailizeVariable()	{		
	
		riderImg=(ImageView)findViewById(R.id.imageViewProfilepic);
		driverImg=(ImageView)findViewById(R.id.imageView_vehiclepic);
		btn_edit_rider=(Button)findViewById(R.id.button_profileedit);
		btn_edit_driver=(Button)findViewById(R.id.button_vehicle_edit);
		btn_signOut=(Button)findViewById(R.id.button_signout);
		txt_ridername=(TextView)findViewById(R.id.textView_name);
		txt_rideremail=(TextView)findViewById(R.id.textView_email);
		txt_rider_mobilenumber=(TextView)findViewById(R.id.textView_phoneno);
		txt_vehicleCompanyName=(TextView)findViewById(R.id.textView_vehiclename);
		txt_vehiclename=(TextView)findViewById(R.id.textView_model);
		txtvehicleNumber=(TextView)findViewById(R.id.textView_number);
		txt_zipCode=(TextView)findViewById(R.id.textView_vehiclezipcode);
		txt_lisenseNo=(TextView)findViewById(R.id.textView_Lisenceno);
		txt_socialSecurityNumber=(TextView)findViewById(R.id.textView_socialsecurityno);
		textView_address=(TextView)findViewById(R.id.textView_address);
	}		
	
	public void clickListner() {
		btn_edit_rider.setOnClickListener(this);
		btn_edit_driver.setOnClickListener(this);
		btn_signOut.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
	
		switch (v.getId()) {

		case R.id.button_profileedit:
			
			Intent i=new Intent(GetProfile.this,EditBaseProfile.class);
			finish();
			startActivity(i);
		
			break;

		case R.id.button_vehicle_edit:
			
			Intent mIntent=new Intent(GetProfile.this,VehicleInformationActivity.class);	
			SingleTon.getInstance().setEdited(true);
			startActivity(mIntent);
		
			break;

		case R.id.button_signout:
			
			/*Intent intent = new Intent(GetProfile.this,LoginActivity.class);
			startActivity(intent);
			finish();*/
			//intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			logout();
			
			
		

		default:

			break;
		}
	
	}
	@Override
	public void onBackPressed() {
	finish();

	}
	private class DownloadImageTask extends AsyncTask<String, Void, Bitmap> {
	    ImageView bmImage;

	    public DownloadImageTask(ImageView bmImage) {
	        this.bmImage = bmImage;
	    }

	    protected Bitmap doInBackground(String... urls) {
	        String urldisplay = urls[0];
	        Bitmap mIcon11 = null;
	        try {
	            InputStream in = new java.net.URL(urldisplay).openStream();
	            mIcon11 = BitmapFactory.decodeStream(in);
	        } catch (Exception e) {
	            Log.e("Error", e.getMessage());
	            e.printStackTrace();
	        }
	        return mIcon11;
	    }

	    protected void onPostExecute(Bitmap result) {
	    
	    	// bm2=result;
	    	riderImg.setImageBitmap(result)	;
	    	// storeImage(result,"name");
	    	//Uri myUri = Uri.parse(mProfileInfoModel.getImage());
	    	//new DownloadImageTask2().execute();
	    	
	    }
	}
	
	 /*private Bitmap rotateImage(Bitmap sourceBitmap, float angle)
	   {
		 Bitmap rotatedBitmap=null;
		 Matrix matrix = new Matrix();
		 matrix.postRotate(90);
		 return rotatedBitmap = Bitmap.createBitmap(sourceBitmap, 0, 0, sourceBitmap.getWidth(), sourceBitmap.getHeight(), matrix, true);
	  
	   }*/
	 
	/* public static String getRealPathFromURI(Uri contentURI,Context context) {
		    String path= contentURI.getPath();
		    try {
		        Cursor cursor = context.getContentResolver().query(contentURI, null, null, null, null);
		        cursor.moveToFirst();
		        String document_id = cursor.getString(0);
		        document_id = document_id.substring(document_id.lastIndexOf(":") + 1);
		        cursor.close();

		        cursor = context.getContentResolver().query(
		                android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
		                null, MediaStore.Images.Media._ID + " = ? ", new String[]{document_id}, null);
		        cursor.moveToFirst();
		        path = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DATA));
		        cursor.close();
		    }
		    catch(Exception e)
		    {
		        return path;
		    }
		    return path;
		}
	 
	 
	 public String Downloadfromurl(String Url)
	 {

		 File file,folder;
	  String filepath=null;

	  try {

	   URL url = new URL(Url);

	   //create the new connection

	   HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();

	   //set up some things on the connection
	   urlConnection.setRequestMethod("GET");

	   urlConnection.setDoOutput(true); 

	    //and connect!

	   urlConnection.connect();

	   //set the path where we want to save the file
	   //in this case, going to save it on the root directory of the
	   //sd card.

	   folder = new File(Environment.getExternalStorageDirectory().toString()+"/img");

	   folder.mkdirs();

	   //create a new file, specifying the path, and the filename
	   //which we want to save the file as.

	   String filename= "page"+1+".PNG";   

	   file = new File(folder,filename);

	   if(file.createNewFile())

	   {

	    file.createNewFile();

	   }

	   //this will be used to write the downloaded data into the file we created
	   FileOutputStream fileOutput = new FileOutputStream(file);

	   //this will be used in reading the data from the internet
	   InputStream inputStream = urlConnection.getInputStream();

	   //this is the total size of the file
	   int totalSize = urlConnection.getContentLength();
	   //variable to store total downloaded bytes
	   int downloadedSize = 0;

	   //create a buffer...
	   byte[] buffer = new byte[1024];
	   int bufferLength = 0; //used to store a temporary size of the buffer

	   //now, read through the input buffer and write the contents to the file
	   while ( (bufferLength = inputStream.read(buffer)) > 0 ) {
	    //add the data in the buffer to the file in the file output stream (the file on the sd card
	    fileOutput.write(buffer, 0, bufferLength);
	    //add up the size so we know how much is downloaded
	    downloadedSize += bufferLength;
	    //this is where you would do something to report the prgress, like this maybe
	    Log.i("Progress:","downloadedSize:"+downloadedSize+"totalSize:"+ totalSize) ;
	   }
	   //close the output stream when done
	   fileOutput.close();
	   if(downloadedSize==totalSize)  
	       filepath=file.getPath();

	  //catch some possible errors...
	  } catch (MalformedURLException e) {
	   e.printStackTrace();
	  } catch (IOException e) {
	   filepath=null;
	   e.printStackTrace();
	  }
	  Log.i("filepath:"," "+filepath) ;


	  return filepath;

	 }
	 private class DownloadImageTask2 extends AsyncTask<String, Void, String> {
		    ImageView bmImage;

		   

		    protected String doInBackground(String... urls) {
		       // String urldisplay = urls[0];
		        String mIcon11 = null;
		        try {
		          
		        	Downloadfromurl(mProfileInfoModel.getImage());
		        } catch (Exception e) {
		            Log.e("Error", e.getMessage());
		            e.printStackTrace();
		        }
		        return mIcon11;
		    }

		    protected void onPostExecute(String path) {
		    
		    
		    	//String path=result;
		    			
		    			//Downloadfromurl(mProfileInfoModel.getImage());
		 		//String path=getRealPathFromURI(myUri,GetProfile.this);
		 		Bitmap ss=ExifUtils.rotateBitmap(path,bm2);
		 		
		 		riderImg.setImageBitmap(ss);
		    }
	
}*/
	/* private boolean storeImage(Bitmap imageData, String name) {
			//get path to external storage (SD card)
			String iconsStoragePath = Environment.getExternalStorageDirectory() + "/myImages/";
			File sdIconStorageDir = new File(iconsStoragePath);

			//create storage directories, if they don't exist
			sdIconStorageDir.mkdirs();

			try {
				String filePath = sdIconStorageDir.toString() ;
				FileOutputStream fileOutputStream = new FileOutputStream(filePath+name);

				BufferedOutputStream bos = new BufferedOutputStream(fileOutputStream);

				//choose another format if PNG doesn't suit you
				imageData.compress(CompressFormat.PNG, 100, bos);

				bos.flush();
				bos.close();

			} catch (FileNotFoundException e) {
				Log.w("TAG", "Error saving image file: " + e.getMessage());
				return false;
			} catch (IOException e) {
				Log.w("TAG", "Error saving image file: " + e.getMessage());
				return false;
			}

			return true;
		}	*/
	 
	 private void logout()
	 {
		 if(Util.isNetworkAvailable(GetProfile.this)){
				ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
				nameValuePairs.add(new BasicNameValuePair("useremail", prefs.getString("useremail", "")));
				Log.e("logout", nameValuePairs.toString());
				
				AsyncTaskForZira mTask = new AsyncTaskForZira(GetProfile.this, "Logout",nameValuePairs, true, "Please wait...");
				mTask.delegate = (AsyncResponseForZira)GetProfile.this;
				mTask.execute();
				}
				else
				{
					Util.alertMessage(GetProfile.this, "Please check your internet connection");
			}
		 
	 }

	@Override
	public void processFinish(String output, String methodName) {
		// TODO Auto-generated method stub
		ZiraParser parser=new ZiraParser();
		Log.e("logout", output);
		if(methodName.equals("Logout"))
		{
			
			String result=parser.Logout(output);
			if(result.equals("0"))
			{
				e.putString("FBAccessToken","");
				e.putLong("FBAccessExpires",0);		
				e.putString("Login", "");
				e.putString("Userid", "");
				e.putString("mode", "");
				e.putString("_Login", "");
				e.clear();
				e.commit();
				
				Intent mIntent=new Intent(GetProfile.this,LoginActivity.class);	
				SingleTon.getInstance().setEdited(true);
				mIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
				startActivity(mIntent);
				}
			else
			{
				Util.alertMessage(GetProfile.this, result);
			}
		}
	}
}
