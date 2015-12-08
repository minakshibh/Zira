package com.zira.notification;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONException;
import org.json.JSONObject;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.twentyfourseven.zira.DriverModeActivity;
import com.twentyfourseven.zira.DriverProfileInformation;
import com.twentyfourseven.zira.R;
import com.twentyfourseven.zira.VehicleSearchActivity;
import com.zira.async_tasks.AsyncResponseForZira;
import com.zira.async_tasks.AsyncTaskForZira;
import com.zira.modal.Coordinates;
import com.zira.modal.GetTripDetails;
import com.zira.modal.Riderlocation;
import com.zira.util.ImageLoader;
import com.zira.util.SingleTon;
import com.zira.util.Util;
import com.zira.util.ZiraParser;

public class DriverNotifications extends Activity implements AsyncResponseForZira , LocationListener{
	String status="",SpiltImage="";
	JSONObject json=new JSONObject();
	String TripId="";
	ProgressDialog pDialog;
	ImageView ImageDriver,img_handicap,cancel_driverimage;
	String messages="";
	String sendbyreq="",currentLoc="",destination="",eta="",tripID="",handicap="",ridername="",
			getRating="",vehicle="",offered_fare="",pickup="",distance="",imageUrl="",requestType="";
	String	jsonResult="",jsonMessage="",pending_jsonMessage="",pending_jsonResult="";
	SharedPreferences prefs;
	TextView timeLeft,sendby,current_Loc,Destination1,rating,pickUpDateTime,
	prefferedVechileType,offered,textViewDistance,txtbackground,txtTimeLeft_LeftSide,
	text_Rapid,text_Message;
	int countdownNumber = 20;
	Button btnAccept,btnReject,btnOk;
	double latitude,longitude;
	private ProgressBar progressBar;
	private int progressStatus = 100;
	private Handler handler = new Handler();
	Riderlocation riderlocation;
	private int progesscheck=1;
	int mapflag=0;
	String tripid="";
	private String paymentStatus="no",CancellationCharges="0";
	
	/////////////////
	public static Boolean tripstart=false,tripcancel=false;

	private Button cancelButton,beginTripButton;

	private Button SeeRouteButton,arrivedButton;
	private LinearLayout bottomLinaerLayout,acceptLinaerLayout,beginJourneyLinaerLayout;
	private String AcceptOrRejectRequest="AcceptOrRejectRequest";
	private ImageLoader imageLoader;
	private RelativeLayout topRelativeLayout,RelativeLayout_map;
	LinearLayout rel_imageandtext,layoutcancel,cancel_layout;
	private TextView counterTextView,txtcancel;
	private TimerTask backgroundTimerTask;    
	private Timer Backgroundtimer;
	private int flag=0;
	private String GetDetailsByTripId="GetDetailsByTripId";
	private String NotifyRegardingArrival="NotifyRegardingArrival";

	private ZiraParser parser;
	private GetTripDetails tripDetailsModal;
	private String selectedDate;
	TextView tv_name,tv_text;
	private int stop=0;
	MediaPlayer mp;
	String url;
	public static int routecheck=0;
	GoogleMap googleMap;
	private LocationManager locationManager;
	//private String provider;
	private static double myLat=0, myLon=0;
	//private Criteria criteria;
	String cancel_tripid,begun_tripid,arrivetripid;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.driver_notifications);

    
	   
		getCurrentDate();
		intilisedlayout();
	
		
		if(getIntent().getStringExtra("accepted")!=null)
		{
			
			initialiseMap();
			DriverArrive();
		}
		else if(getIntent().getStringExtra("arrived")!=null)
		{
			
			initialiseMap();
			 DriverBegun();
		}
		else if(getIntent().getStringExtra("cancel")!=null)
		{
			initialiseMap();
			rel_imageandtext.setVisibility(View.GONE);
			bottomLinaerLayout.setVisibility(View.GONE);
			acceptLinaerLayout.setVisibility(View.GONE);
			beginJourneyLinaerLayout.setVisibility(View.GONE);
			layoutcancel.setVisibility(View.GONE);
			
			RelativeLayout_map.setVisibility(View.VISIBLE);
			cancel_layout.setVisibility(View.VISIBLE);
			txtcancel.setText(prefs.getString("Receivedcancelmessage", ""));
			
			imageLoader = new ImageLoader(DriverNotifications.this);
			imageLoader.DisplayImage(prefs.getString("ReceivednotificationImag", ""),cancel_driverimage);
			
		}
		else
		{
			openProgressBar();
			startBackgroundTimer();
			setFinishOnTouchOutside(false);
		try{
			mp = new MediaPlayer();
			mp = MediaPlayer.create(DriverNotifications.this,R.raw.newsound);
			mp.setAudioStreamType(AudioManager.STREAM_MUSIC);
			mp.start();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		
		// openProgressBar();
				topRelativeLayout.setOnClickListener(new OnClickListener() {
					public void onClick(View v) {
						progesscheck=0;
						if(flag==0){
							stopBackgroundTimer();
						try{
							mp.stop();
						}
						catch(Exception e)
						{
							e.printStackTrace();
						}
							Editor editor = prefs.edit();
							editor.putInt("not_flag", 0);
							editor.commit();
							status = "Accepted";
							if(Util.isNetworkAvailable(DriverNotifications.this))

							{
							ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(1);
							nameValuePairs.add(new BasicNameValuePair("tripid",prefs.getString("ReceivednotificationTripID", "").trim()));
							nameValuePairs.add(new BasicNameValuePair("status", "Accepted"));
							//nameValuePairs.add(new BasicNameValuePair("deviceType", "android"));
							AsyncTaskForZira mFetchStates = new AsyncTaskForZira(DriverNotifications.this, AcceptOrRejectRequest,nameValuePairs,true,"Please wait...");
							mFetchStates.delegate = (AsyncResponseForZira)DriverNotifications.this;
							mFetchStates.execute();
							getCurrentDate();
							}
							else
							{
								Util.alertMessage(DriverNotifications.this, "Please check your internet connection");		
							}
						}
					}
				});
		
		}
	
		cancel_layout.setOnClickListener(new OnClickListener() {
		public void onClick(View v) {
			
			Intent i=new Intent(DriverNotifications.this,DriverModeActivity.class);
			startActivity(i);
			finish();
				
			}
		});
	
	
		imageLoader = new ImageLoader(DriverNotifications.this);
		imageLoader.DisplayImage(prefs.getString("ReceivednotificationImag", ""),ImageDriver);

		
		if(prefs.getString("activetripid", "").equals(""))
		{
			cancel_tripid=prefs.getString("ReceivednotificationTripID", "");
			
		}
		else
		{
			cancel_tripid=prefs.getString("activetripid", "");
		}
		cancelButton.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				
				if(Util.isNetworkAvailable(DriverNotifications.this))

				{
				ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
				status = "Cancel";
				params.add(new BasicNameValuePair("TripId",cancel_tripid));
				params.add(new BasicNameValuePair("Status", "Cancel"));
				params.add(new BasicNameValuePair("Timestamp",selectedDate));
				params.add(new BasicNameValuePair("Latitude",String.valueOf(myLat)));
				params.add(new BasicNameValuePair("Longitude",String.valueOf(myLon)));
				params.add(new BasicNameValuePair("TripMilesActual", ""));
				params.add(new BasicNameValuePair("TripTimeActual", ""));
				params.add(new BasicNameValuePair("TripAmountActual", ""));				 
				params.add(new BasicNameValuePair("Trigger", "driver"));
				params.add(new BasicNameValuePair("PaymentStatus", paymentStatus));
				params.add(new BasicNameValuePair("CancellationCharges",CancellationCharges ));
				//params.add(new BasicNameValuePair("deviceType", "android"));

				Log.e("tag", "NotifyRegardingArrival :"+params.toString());
				AsyncTaskForZira mWebPageTask1 = new AsyncTaskForZira(DriverNotifications.this, NotifyRegardingArrival, params, true,"Cancelling Request...");
				mWebPageTask1.delegate = (AsyncResponseForZira) DriverNotifications.this;
				mWebPageTask1.execute();

				}
				else
				{
					Util.alertMessage(DriverNotifications.this, "Please check your internet connection");		
				}
			}
		});
		

		SeeRouteButton.setOnClickListener(new OnClickListener() {

			public void onClick(View v) {
				if(routecheck==0)
				{
					Toast.makeText(DriverNotifications.this, "Please wait...", 1).show();
					}
				else
				{
				String getGetTrip_StartingAddress=prefs.getString("tripstarting_loc", "");
				//System.err.println("getGetTrip_StartingAddress"+getGetTrip_StartingAddress);
				getGetTrip_StartingAddress.replace(" ", "+");

					if(isGoogleMapsInstalled())
					{
					
						Intent intent = new Intent(android.content.Intent.ACTION_VIEW,Uri.parse("google.navigation:q="+prefs.getString("tripstarttlat", "")+","+prefs.getString("tripstartlong", "")));
						intent.setPackage("com.google.android.apps.maps");
						startActivity(intent);
						}
					else
					{
											
					url="http://maps.google.com/maps?daddr="+getGetTrip_StartingAddress+"&x-success=sourceapp://?resume=true&x-source=AirApp";
					Intent intent = new Intent(android.content.Intent.ACTION_VIEW,Uri.parse(url));
					startActivity(intent);
					
					}
				}
			}
		});
		
		if(prefs.getString("activetripid", "").equals(""))
		{
			begun_tripid=prefs.getString("ReceivednotificationTripID", "");
			
			}
			else
			{
				begun_tripid=prefs.getString("activetripid", "");
						
				}
		beginTripButton.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				/////////////
				tripstart=true;

				status = "BeginTrip";
				if(Util.isNetworkAvailable(DriverNotifications.this))

				{
				ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
				params.add(new BasicNameValuePair("TripId",begun_tripid));
				params.add(new BasicNameValuePair("Status", "BeginTrip"));
				params.add(new BasicNameValuePair("Timestamp",selectedDate));
				params.add(new BasicNameValuePair("Latitude",String.valueOf(myLat)));
				params.add(new BasicNameValuePair("Longitude",String.valueOf(myLon)));
				params.add(new BasicNameValuePair("TripMilesActual", ""));
				params.add(new BasicNameValuePair("TripTimeActual", ""));
				params.add(new BasicNameValuePair("TripAmountActual", ""));				 
				params.add(new BasicNameValuePair("Trigger", ""));
				params.add(new BasicNameValuePair("PaymentStatus", ""));
				params.add(new BasicNameValuePair("CancellationCharges", ""));
			//	params.add(new BasicNameValuePair("deviceType", "android"));

				Log.e("tag", "NotifyRegardingArrival :"+params.toString());
				AsyncTaskForZira mWebPageTask1 = new AsyncTaskForZira(DriverNotifications.this, NotifyRegardingArrival, params, true,"Please wait..");
				mWebPageTask1.delegate = (AsyncResponseForZira) DriverNotifications.this;
				mWebPageTask1.execute();
			}
			else
			{
				Util.alertMessage(DriverNotifications.this, "Please check your internet connection");		
			}
			stop=1;

			}
		});

		if(prefs.getString("activetripid", "").equals(""))
		{
			arrivetripid=prefs.getString("ReceivednotificationTripID", "");
			
			}
			else
			{
				arrivetripid=prefs.getString("activetripid", "");
				}
		
		arrivedButton.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				status = "Arrived";
				
				startTimer_Cancel();
				if(Util.isNetworkAvailable(DriverNotifications.this))

				{
				ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
				
				params.add(new BasicNameValuePair("TripId",arrivetripid));
			
				params.add(new BasicNameValuePair("Status", "Arrived"));
				params.add(new BasicNameValuePair("Timestamp",selectedDate));
				params.add(new BasicNameValuePair("Latitude",String.valueOf(myLat)));
				params.add(new BasicNameValuePair("Longitude",String.valueOf(myLon)));
				params.add(new BasicNameValuePair("TripMilesActual", ""));
				params.add(new BasicNameValuePair("TripTimeActual", ""));
				params.add(new BasicNameValuePair("TripAmountActual", ""));				 
				params.add(new BasicNameValuePair("Trigger", ""));
				params.add(new BasicNameValuePair("PaymentStatus", "no"));
				params.add(new BasicNameValuePair("CancellationCharges", ""));
				//params.add(new BasicNameValuePair("deviceType", "android"));

				Log.e("tag", "NotifyRegardingArrival :"+params.toString());
				AsyncTaskForZira mWebPageTask1 = new AsyncTaskForZira(DriverNotifications.this, NotifyRegardingArrival, params, true, "Please wait..");
				mWebPageTask1.delegate = (AsyncResponseForZira) DriverNotifications.this;
				mWebPageTask1.execute();
				}
				else
				{
					Util.alertMessage(DriverNotifications.this, "Please check your internet connection");		
				}
			}
		});


		
	

	}

	protected void startTimer_Cancel() {
		stopTimer_Cancel();
		Backgroundtimer = new Timer();
		initializeTimer_cancel();
		Backgroundtimer.schedule(backgroundTimerTask, 5*60000, 5*60000);
		System.out.println("backtimerStart");
		Log.e("","backtimerStart");	

	}
	private void initializeTimer_cancel() {
		backgroundTimerTask = new TimerTask() {
			public void run() {
			runOnUiThread(new Runnable() {
					@Override
					public void run() {
						paymentStatus="yes";
						CancellationCharges=prefs.getString("cancelcharge", "");
						System.err.println("paymentstatus="+paymentStatus);
						stopTimer_Cancel();
					
					}
				});
			}
		};
	}
	public void stopTimer_Cancel() {

		if (Backgroundtimer != null) {
			Backgroundtimer.cancel();
			Backgroundtimer = null;
			System.out.println("backtimerStop");
			Log.e("","backtimerStop");	
		}
	}
	private void DriverBegun() {
		rel_imageandtext.setVisibility(View.GONE);
		bottomLinaerLayout.setVisibility(View.GONE);
		acceptLinaerLayout.setVisibility(View.GONE);
		beginJourneyLinaerLayout.setVisibility(View.VISIBLE);
		layoutcancel.setVisibility(View.VISIBLE);
		RelativeLayout_map.setVisibility(View.VISIBLE);
		
	}
	public void	DriverArrive()
	{
		layoutcancel.setVisibility(View.GONE);
		rel_imageandtext.setVisibility(View.GONE);
		bottomLinaerLayout.setVisibility(View.GONE);
		acceptLinaerLayout.setVisibility(View.VISIBLE);
		RelativeLayout_map.setVisibility(View.VISIBLE);
	}
	
	public void	intilisedlayout()
	{
	prefs = this.getSharedPreferences("Zira", MODE_PRIVATE);
	parser = new ZiraParser();
	riderlocation=new Riderlocation();
	tv_name=(TextView)findViewById(R.id.textView_name);
	tv_text=(TextView)findViewById(R.id.textView_text);
	tv_name.setText(prefs.getString("ReceivednotificationName", ""));
	tv_text.setText(prefs.getString("ReceivednotificationSentMessage", ""));
	//ImageDriver=(ImageView)findViewById(R.id.imageViewDriverImage);
	cancel_driverimage=(ImageView)findViewById(R.id.cancel_driverimage);
	txtcancel=(TextView)findViewById(R.id.txtcancel);
	cancelButton=(Button)findViewById(R.id.cancelButton);
	//After_seeRouteButton=(Button)findViewById(R.id.After_seeRouteButton);
	beginTripButton=(Button)findViewById(R.id.beginTripButton);
	beginJourneyLinaerLayout=(LinearLayout)findViewById(R.id.beginJourneyLinaerLayout);
	progressBar=(ProgressBar)findViewById(R.id.progressBar1);
	ImageDriver=(ImageView)findViewById(R.id.imageViewDriverImage);
	cancel_layout=(LinearLayout)findViewById(R.id.cancel_layout);
	
	rel_imageandtext=(LinearLayout)findViewById(R.id.rel_imageandtext);
	topRelativeLayout=(RelativeLayout)findViewById(R.id.topRelativeLayout);
	RelativeLayout_map=(RelativeLayout)findViewById(R.id.RelativeLayout_map);
	RelativeLayout_map.setVisibility(View.GONE);
	counterTextView=(TextView)findViewById(R.id.counterTextView);
	bottomLinaerLayout=(LinearLayout)findViewById(R.id.bottomLinaerLayout);
	acceptLinaerLayout=(LinearLayout)findViewById(R.id.acceptLinaerLayout);
	acceptLinaerLayout.setVisibility(View.GONE);
	layoutcancel=(LinearLayout)findViewById(R.id.cancel);
	layoutcancel.setVisibility(View.GONE);
	text_Message=(TextView)findViewById(R.id.textViewShowDriverMessage);	
	SeeRouteButton=(Button)findViewById(R.id.SeeRouteButton);	
	arrivedButton=(Button)findViewById(R.id.arrivedButton);		
	}
	public boolean isGoogleMapsInstalled()
	{
	    try
	    {
	        ApplicationInfo info = getPackageManager().getApplicationInfo("com.google.android.apps.maps", 0 );
	        return true;
	    } 
	    catch(PackageManager.NameNotFoundException e)
	    {
	        return false;
	    }
	}
	protected void getCurrentDate() {
		Calendar mCalendar=Calendar.getInstance();	
		SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		selectedDate=df.format(mCalendar.getTime());
		System.out.println(selectedDate);
	}



	private void initializeBackgroundTimerTask() {
		backgroundTimerTask = new TimerTask() {
			public void run() {

				runOnUiThread(new Runnable() {
					@Override
					public void run() {
						if(countdownNumber == 0) {
							//cancel();
							stopBackgroundTimer();
							Editor editor = prefs.edit();
							editor.putInt("not_flag", 0);
							editor.commit();
							
							finish();
							//Toast.makeText(DriverNotifications.this, "Request Cancelled", 0).show();
							progressBar.setProgress(countdownNumber);
						}
						counterTextView.setText(String.valueOf(countdownNumber));
						countdownNumber--;
					}
				});
			}
		};
	}

	protected void startBackgroundTimer() {
		stopBackgroundTimer();

		Backgroundtimer = new Timer();
		initializeBackgroundTimerTask();
		Backgroundtimer.schedule(backgroundTimerTask, 0, 1000);
		System.out.println("backtimerStart");
		Log.e("","backtimerStart");	

	}

	public void stopBackgroundTimer() {

		if (Backgroundtimer != null) {
			Backgroundtimer.cancel();
			Backgroundtimer = null;
			System.out.println("backtimerStop");
			Log.e("","backtimerStop");	
		}
	}



	public void processFinish(String output, String methodName) {


		String jsonResult1 = null;
		JSONObject obj;
		try {
			obj = new JSONObject(output);
			String jsonMessage=obj.getString("message");
			jsonResult1=obj.getString("result");
//			Toast.makeText(DriverNotifications.this, jsonMessage, 0).show();
		}catch(JSONException exception){

		}
		
		if(methodName.equals(AcceptOrRejectRequest)){
			/*System.err.println("Accepted");
			finish();*/
			Log.e("AcceptOrRejectRequest", output);	
			
			String jsonResult = null;
			JSONObject acceptObj;
			try {
				acceptObj = new JSONObject(output);
				String jsonMessage=acceptObj.getString("message");
				
				jsonResult=acceptObj.getString("result");
				riderlocation.setResult(jsonResult);
				String rider_lat=acceptObj.getString("rider_lat");
				riderlocation.setRiderlat(rider_lat);
				String rider_lon=acceptObj.getString("rider_long");
				riderlocation.setRiderlog(rider_lon);
				Editor ed=prefs.edit();
				ed.putString("riderlat", rider_lat);
				ed.putString("riderlon", rider_lon);
				ed.commit();
//				Toast.makeText(DriverNotifications.this, jsonMessage, 0).show();
			}catch(JSONException exception){

			}
			

			if(jsonResult.equals("0")){
				
				flag=1;
				initialiseMap();
				rel_imageandtext.setVisibility(View.GONE);
				bottomLinaerLayout.setVisibility(View.GONE);
				acceptLinaerLayout.setVisibility(View.VISIBLE);
				RelativeLayout_map.setVisibility(View.VISIBLE);
				
				ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(1);
				nameValuePairs.add(new BasicNameValuePair("TripId",prefs.getString("ReceivednotificationTripID", "")));
				AsyncTaskForZira mFetchStates = new AsyncTaskForZira(DriverNotifications.this, GetDetailsByTripId,nameValuePairs, false, "");
				mFetchStates.delegate = (AsyncResponseForZira) DriverNotifications.this;
				mFetchStates.execute();
			}
		}
		else if(methodName.equals(GetDetailsByTripId)){
			System.err.println("GetDetailsByTripId"+output);
			routecheck=1;
			tripDetailsModal = parser.parsegetTripDetails(output);
			SingleTon.getInstance().setGetTripDetail(tripDetailsModal);

		}

		else if(methodName.equals(NotifyRegardingArrival)){
			System.err.println("NotifyRegardingArrival"+output);
			if(jsonResult1.equals("0")){
				layoutcancel.setVisibility(View.VISIBLE);
				acceptLinaerLayout.setVisibility(View.GONE);
				rel_imageandtext.setVisibility(View.GONE);
				beginJourneyLinaerLayout.setVisibility(View.VISIBLE);
			
				//onLocationChanged(location));
//				Toast.makeText(DriverNotifications.this, "arrived", 0).show();
				if(stop==1){
					
					finish();
					DriverModeActivity.fromActivtyDriverNotification=1;
					tripcancel=false;
					
				}else if(status.equals("Cancel")){
					//System.err.println("Cancel"+output);
					finish();
					tripcancel=true;
					DriverModeActivity.fromActivtyDriverNotification=1;
					startActivity(new Intent(DriverNotifications.this,DriverModeActivity.class));	
				}
				
			}
			else{
				Toast.makeText(DriverNotifications.this, "Something is worng,Please try Later", 0).show();
			}

		}
	}
@Override
protected void onResume() {
	//intilisedlayout();
	// initialiseMap();
	super.onResume();
}
/*public void stopService{


if(mt.isAlive())
{
	progressBar.setProgress(progressStatus);
mt.stopThread();// mt is the object of myThread class
}*/
//}
	public void openProgressBar()
	{
		new Thread(new Runnable() {
			public void run() {
				while (progressStatus > 0) {
					if(progesscheck==1)
					{
						progressStatus -= 5;
						}
					// Update the progress bar and display the 
					//current value in the text view
					handler.post(new Runnable() {
						public void run() {
							progressBar.setProgress(progressStatus);
							//  textView.setText(progressStatus+"/"+progressBar.getMax());
						}
					});
					try {
						// Sleep for 200 milliseconds. 
						//Just to display the progress slowly
						Thread.sleep(1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			}
		}).start();
	}
	
	private void initialiseMap() {
				
		googleMap = ((MapFragment) getFragmentManager().findFragmentById(R.id.map)).getMap();
		googleMap.setMyLocationEnabled(true); 
		googleMap.getUiSettings().setMyLocationButtonEnabled(false);
		googleMap.getUiSettings().setZoomControlsEnabled(false);
		
		if (googleMap != null) {
			boolean enabledGPS = false ;
			boolean enabledWiFi=false;
			
			
			locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
			//criteria = new Criteria();

			// Getting the name of the best provider
			//provider = locationManager.getBestProvider(criteria, true);
		      Location location = getLastKnownLocation();
		      
		      if(location!=null){
	              onLocationChanged(location);
	          }
		      try{
					enabledGPS = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
					enabledWiFi = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

					// Check if enabled and if not send user to the GSP settings
					if (!enabledGPS && !enabledWiFi) {
						Toast.makeText(DriverNotifications.this, "GPS signal not found", Toast.LENGTH_LONG).show();
						Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
						startActivity(intent);
					}
				}catch(Exception e){
					e.printStackTrace();
				}

				if(enabledGPS)
				{
					locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 10000, 0, this);
					}
				else if(enabledWiFi)
				{
					locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 10000, 0, this);
					}
	  	
		}
	   

		//locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 10000, 0, this);
		
	}
	
		
		
	
	public void onLocationChanged(Location location) {
			try{
					//criteria = new Criteria();
					//provider = locationManager.getBestProvider(criteria, true);
					location = getLastKnownLocation();	
			
					myLat = location.getLatitude();

					// Getting longitude of the current location
					myLon = location.getLongitude();

					Log.e("on current location==","lat : "+myLat+" , lon : "+myLon);


					// Creating a LatLng object for the current location
					//LatLng latLng = new LatLng(myLat, myLon);
					googleMap.clear();
					googleMap.addMarker(new MarkerOptions().position(new LatLng(myLat, myLon)).icon(BitmapDescriptorFactory.fromResource(R.drawable.car_icon)));
					// Showing the current location in Google Map
					CameraPosition cameraPosition = new CameraPosition.Builder()
					.target(new LatLng(myLat, myLon)).zoom(15).build();
				  	googleMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
				  	
				  	googleMap.addMarker(new MarkerOptions().position(new LatLng(Double.parseDouble(prefs.getString("riderlat", "")),
					Double.parseDouble(prefs.getString("riderlon", "")))).icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN)));

			}
			catch(Exception e)
			{
				
			}
	}
					
	private Location getLastKnownLocation() {
	    List<String> providers = locationManager.getProviders(true);
	    Location bestLocation = null;
	    for (String provider : providers) {
	        Location l = locationManager.getLastKnownLocation(provider);
	      //  Log.d("last known location, provider: %s, location: %s", provider, l);

	        if (l == null) {
	            continue;
	        }
	        if (bestLocation == null|| l.getAccuracy() < bestLocation.getAccuracy()) {
	           // ALog.d("found best last known location: %s", l);
	            bestLocation = l;
	        }
	    }
	    if (bestLocation == null) {
	        return null;
	    }
	    return bestLocation;
	} 			

@Override
public void onBackPressed() {

}
@Override
public void onStatusChanged(String provider, int status, Bundle extras) {
	// TODO Auto-generated method stub
	
}
@Override
public void onProviderEnabled(String provider) {
	// TODO Auto-generated method stub
	
}
@Override
public void onProviderDisabled(String provider) {
	// TODO Auto-generated method stub
	
}


}


