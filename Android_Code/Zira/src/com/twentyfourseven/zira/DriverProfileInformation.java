package com.twentyfourseven.zira;

import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONObject;
import com.twentyfourseven.zira.R;
import com.zira.async_tasks.AsyncResponseForZira;
import com.zira.async_tasks.AsyncTaskForZira;
import com.zira.modal.GetTripDetails;
import com.zira.modal.Riderlocation;
import com.zira.notification.RiderNotification;
import com.zira.util.SingleTon;
import com.zira.util.Util;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

public class DriverProfileInformation extends Activity implements OnClickListener, AsyncResponseForZira {
	private ImageView imgDriver, imgVehicle, imgMessage, imgPhone, star1, star2, star3,
			star4, star5, imageCancel;
	private TextView txtDriverName, txtVehicleMake, txtVehicleModel, txtvehicleNumber;
	Button btnSeeDriverLocation, btnSend;
	JSONObject jsonObject = new JSONObject();
	ProgressDialog pDialog;
	Button txt_cancelride;
	String jsonResult = "", jsonMessage = "", jsonDriverName = "",
			jsonVehicleModel = "", jsonVehicleMake = "",
			jsonVehicleNumber = "", jsonDriverImageUrl = "",
			jsonDriverVehicleUrl = "", jsonRating = "",jsonmobileno="";
	String urlGetDetail = "", urlSendMessage = "";
	LinearLayout layoutDialog;
	EditText edtMessage;
	String getProfile = "GetProfiles";
	String sendMessages = "SendMessages",selectedDate;
	private GetTripDetails mTripDetailsModel;
	private SharedPreferences prefs;
	//private String CancellationCharges="0",rider_paymentStatus="no";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.new_driver_profile_information);
		
		intializeVariable();
		// new GetDetailParsing().execute();
		String userid =prefs.getString("driverIdTripId", "");
		Log.e("tag", "userid:" + userid);
		// Building Parameters
		
		if(Util.isNetworkAvailable(DriverProfileInformation.this))

		{
		ArrayList<NameValuePair> params1 = new ArrayList<NameValuePair>();
		params1.add(new BasicNameValuePair("UserId", prefs.getString("driverIdTripId", "")));

		AsyncTaskForZira mWebPageTask = new AsyncTaskForZira(
				DriverProfileInformation.this, getProfile, params1, true, "Please wait..");
		mWebPageTask.delegate = (AsyncResponseForZira) DriverProfileInformation.this;
		mWebPageTask.execute();
		}
		else
		{
			Util.alertMessage(DriverProfileInformation.this, "Please check your internet connection");	
		}

	}

	public void intializeVariable() {
		prefs = getSharedPreferences("Zira", MODE_PRIVATE);
		RiderNotification.rider_paymentStatus="no";
	 	RiderNotification.rider_CancellationCharges="0";
		mTripDetailsModel=SingleTon.getInstance().getGetTripDetail();
		imgDriver = (ImageView) findViewById(R.id.imageViewProfilepic);
		imgVehicle = (ImageView) findViewById(R.id.VehiclesImageInProfileInformation);
		imgMessage = (ImageView) findViewById(R.id.imageView_Message);
		imgPhone=(ImageView)findViewById(R.id.imageView_Phone);
		star1 = (ImageView) findViewById(R.id.imageStar1);
		star2 = (ImageView) findViewById(R.id.imageStar2);
		star3 = (ImageView) findViewById(R.id.imageStar3);
		star4 = (ImageView) findViewById(R.id.imageStar4);
		star5 = (ImageView) findViewById(R.id.imageStar5);
		txtDriverName = (TextView) findViewById(R.id.txtDriverName);
		txtVehicleMake = (TextView) findViewById(R.id.txVehicleMake);
		txtVehicleModel = (TextView) findViewById(R.id.textViewVehilceModel);
		txt_cancelride = (Button) findViewById(R.id.txt_cancelride);
		txtvehicleNumber = (TextView) findViewById(R.id.textView_vehicleNumber);
		btnSeeDriverLocation = (Button) findViewById(R.id.btnSeeDriverLocation);
		layoutDialog = (LinearLayout) findViewById(R.id.dialogSend);
		layoutDialog.setVisibility(View.GONE);
		imageCancel = (ImageView) findViewById(R.id.imageViewDelete);
		edtMessage = (EditText) findViewById(R.id.editTextSendMessage);
		btnSend = (Button) findViewById(R.id.buttonSend);
		
		imgMessage.setOnClickListener(this);
		btnSend.setOnClickListener(this);
		imageCancel.setOnClickListener(this);
		btnSeeDriverLocation.setOnClickListener(this);
		txt_cancelride.setOnClickListener(this);
	}

	// show driver Image by using loading image from url
	private class LoadProfileImage extends AsyncTask<String, Void, Bitmap> {
		ImageView bmImage;

		public LoadProfileImage(ImageView bmImage) {
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
			bmImage.setImageBitmap(result);
		}
	}

	// show vehicle Image by using loading image from url
	private class LoadVehicleImage extends AsyncTask<String, Void, Bitmap> {
		ImageView bmImage;

		public LoadVehicleImage(ImageView bmImage) {
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
			bmImage.setImageBitmap(result);
		}
	}

	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.btnSeeDriverLocation:
			// Building Parameters tripId and DriverId
			if(Util.isNetworkAvailable(DriverProfileInformation.this)){
			ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
			params.add(new BasicNameValuePair("DriverId", mTripDetailsModel.getGetTrip_DriverId()));
			params.add(new BasicNameValuePair("TripId", SingleTon.getInstance().getDriverTripId()));
					
			Log.d("tag", "GetDriver Location::"+params.toString());
			AsyncTaskForZira mWebPageTask1 = new AsyncTaskForZira(
					DriverProfileInformation.this, "GetDriverLocation", params,false,"");
			mWebPageTask1.delegate = (AsyncResponseForZira) DriverProfileInformation.this;
			mWebPageTask1.execute();
			}
			else
			{
				Util.alertMessage(DriverProfileInformation.this, "Please check your internet connection");
				}
			break;
		case R.id.imageView_Message:
			InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
			imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
			layoutDialog.setVisibility(View.VISIBLE);
			break;
		case R.id.buttonSend:
			try {
				InputMethodManager imm1 = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
				imm1.hideSoftInputFromWindow(
						getCurrentFocus().getWindowToken(), 0);
			} catch (Exception e) {
				// TODO: handle exception
			}
			if (edtMessage.getText().length() == 0) {
				Util.alertMessage(DriverProfileInformation.this,"Please Write Message");
			} else {
				
				String userid = mTripDetailsModel.getGetTrip_DriverId();
				String message = edtMessage.getText().toString();
				String trigger = "sms";
				Log.i("tag", "userid:" + userid);
				Log.i("tag", "message:" + message);
				Log.i("tag", "trigger:" + trigger);
				// Building Parameters
				if(Util.isNetworkAvailable(DriverProfileInformation.this)){
				ArrayList<NameValuePair> params1 = new ArrayList<NameValuePair>();
				params1.add(new BasicNameValuePair("Id", prefs.getString("driverIdTripId", "")));
				params1.add(new BasicNameValuePair("message", message));
				params1.add(new BasicNameValuePair("trigger", trigger));
				
				Log.d("tag", "SendRequest::"+params1.toString());
				AsyncTaskForZira mWebPageTask = new AsyncTaskForZira(
						DriverProfileInformation.this, sendMessages, params1,true,"Sending message...");
				mWebPageTask.delegate = (AsyncResponseForZira) DriverProfileInformation.this;
				mWebPageTask.execute();
				}
				else
				{
					Util.alertMessage(DriverProfileInformation.this, "Please check your internet connection");
					}
//				new SendMessageParsing().execute();
				edtMessage.setText("");
				}
	
			break;
		case R.id.imageViewDelete:
			try {
				InputMethodManager imm1 = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
				imm1.hideSoftInputFromWindow(
						getCurrentFocus().getWindowToken(), 0);
			} catch (Exception e) {
				// TODO: handle exception
			}
			edtMessage.setText("");
			layoutDialog.setVisibility(View.GONE);
			break;
			
		case R.id.txt_cancelride:
			AlertDialog.Builder alert = new AlertDialog.Builder(DriverProfileInformation.this);
			alert.setTitle("Zira 24/7");
			alert.setMessage("Are you sure you want to cancel ride.?");
			alert.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface arg0, int arg1) {
			
				cancelRide();
				}
			});
			alert.setNegativeButton("No", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface arg0, int arg1) {
					
					
				}
			});
			alert.show();
			
			break;
		}
		
	}
	public void cancelRide()
	{
		getCurrentDate();
		if(Util.isNetworkAvailable(DriverProfileInformation.this)){
			ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
			
			params.add(new BasicNameValuePair("TripId",prefs.getString("driverTripId", "")));
			params.add(new BasicNameValuePair("Status", "Cancel"));
			params.add(new BasicNameValuePair("Timestamp",selectedDate));
			params.add(new BasicNameValuePair("Latitude",""));//String.valueOf(myLat)));
			params.add(new BasicNameValuePair("Longitude",""));//String.valueOf(myLon)));
			params.add(new BasicNameValuePair("TripMilesActual", ""));
			params.add(new BasicNameValuePair("TripTimeActual", ""));
			params.add(new BasicNameValuePair("TripAmountActual", ""));				 
			params.add(new BasicNameValuePair("Trigger", "rider"));
			params.add(new BasicNameValuePair("PaymentStatus", RiderNotification.rider_paymentStatus));
			params.add(new BasicNameValuePair("CancellationCharges",RiderNotification.rider_CancellationCharges ));
			

			Log.e("tag", "cancel NotifyRegardingArrival :"+params.toString());
			AsyncTaskForZira mWebPageTask1 = new AsyncTaskForZira(DriverProfileInformation.this, "NotifyRegardingArrival", params, true,"Cancelling Request...");
			mWebPageTask1.delegate = (AsyncResponseForZira) DriverProfileInformation.this;
			mWebPageTask1.execute();
			}
			else
			{
				Util.alertMessage(DriverProfileInformation.this, "Please check your internet connection");
				}
	}
	protected void getCurrentDate() {
		Calendar mCalendar=Calendar.getInstance();	
		SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		selectedDate=df.format(mCalendar.getTime());
		System.out.println(selectedDate);
	}
	@Override
	public void processFinish(String output, String methodName) {
		// TODO Auto-generated method stub
		Log.i("tag", "Result:" + output);
		if (methodName.equals(getProfile)) {
			try {
				JSONObject obj = new JSONObject(output);
				jsonResult = obj.getString("result");
				jsonMessage = obj.getString("message");

				jsonDriverImageUrl = obj.getString("image");
				jsonDriverVehicleUrl = obj.getString("vechile_img_location");
				jsonDriverName = obj.getString("firstname") + " "
						+ obj.getString("lastname");
				jsonVehicleMake = obj.getString("vechile_make");
				jsonVehicleModel = obj.getString("vechile_model");
				jsonVehicleNumber = obj.getString("licenseplatenumber");
				jsonRating = obj.getString("driver_rating");
				//jsonmobileno = obj.getString("mobile");

				if (jsonResult.equals("0")) {
					new LoadProfileImage(imgDriver).execute(jsonDriverImageUrl);
					new LoadVehicleImage(imgVehicle)
							.execute(jsonDriverVehicleUrl);
					txtDriverName.setText(jsonDriverName);
					txtVehicleMake.setText(jsonVehicleMake);
					txtVehicleModel.setText(jsonVehicleModel);
					txtvehicleNumber.setText(jsonVehicleNumber);
					Log.d("tag", "jsonRating:" + jsonRating);
					if (jsonRating.equals("1")) {
						star1.setImageResource(R.drawable.star_active);
					} else if (jsonRating.equals("2")) {
						star1.setImageResource(R.drawable.star_active);
						star2.setImageResource(R.drawable.star_active);
					} else if (jsonRating.equals("3")) {
						star1.setImageResource(R.drawable.star_active);
						star2.setImageResource(R.drawable.star_active);
						star3.setImageResource(R.drawable.star_active);
					} else if (jsonRating.equals("4")) {
						star1.setImageResource(R.drawable.star_active);
						star2.setImageResource(R.drawable.star_active);
						star3.setImageResource(R.drawable.star_active);
						star4.setImageResource(R.drawable.star_active);
					} else if (jsonRating.equals("5")) {
						star1.setImageResource(R.drawable.star_active);
						star2.setImageResource(R.drawable.star_active);
						star3.setImageResource(R.drawable.star_active);
						star4.setImageResource(R.drawable.star_active);
						star5.setImageResource(R.drawable.star_active);
					}

				}

				else {
					Util.alertMessage(DriverProfileInformation.this,jsonMessage);
				}
			} catch (Exception e) {
			}
		}
		else if(methodName.equals(sendMessages))
		{
			try{
			JSONObject obj = new JSONObject(output);
			jsonResult = obj.getString("result");
			jsonMessage = obj.getString("message");
			if (jsonResult.equals("0")) {

				Util.alertMessage(DriverProfileInformation.this, "Message sent successful");
				layoutDialog.setVisibility(View.GONE);
			}

			else {
				if (jsonMessage.contains("Unable")) {
					Util.alertMessage(DriverProfileInformation.this,
							"Number is not registered.");
				} else {
					Util.alertMessage(DriverProfileInformation.this,jsonMessage);
				}
			}
			}
			catch(Exception e)
			{
				System.out.println(e);
			}
		}
		else if(methodName.equals("GetDriverLocation"))
		{
			try{
				JSONObject obj = new JSONObject(output);
				jsonResult = obj.getString("result");
				jsonMessage = obj.getString("message");
				String jsonDriverLongitude=obj.getString("longitude");
				String jsondDriverLatitude=obj.getString("latitude");
				if (jsonResult.equals("0")) {

//					Util.alertMessage(DriverProfileInformation.this, jsonMessage);
					Intent i=new Intent(DriverProfileInformation.this,SeeDriverLocation.class);
					i.putExtra("JsonDriverLongitude", jsonDriverLongitude);
					i.putExtra("JsonDriverLatitude", jsondDriverLatitude);
					startActivity(i);
				}

				else {
					Util.alertMessage(DriverProfileInformation.this,jsonMessage);
					}
				}
				catch(Exception e)
				{
					System.out.println(e);
				}
		}
		else if(methodName.equals("NotifyRegardingArrival"))
		{
			try{
				JSONObject obj = new JSONObject(output);
				jsonResult = obj.getString("result");
				jsonMessage = obj.getString("message");
			
				if (jsonResult.equals("0")) {

					Intent i=new Intent(DriverProfileInformation.this,VehicleSearchActivity.class);
					finish();
					startActivity(i);
				}

				else {
						Util.alertMessage(DriverProfileInformation.this,jsonMessage);
						}
			
			
		}
			catch(Exception e)
			{
				e.printStackTrace();
				}
			}
	}

}
