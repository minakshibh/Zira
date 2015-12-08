package com.zira.notification;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Color;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.ImageView;
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
import com.google.android.gms.maps.model.PolylineOptions;
import com.twentyfourseven.zira.DirectionsJSONParser;
import com.twentyfourseven.zira.R;
import com.twentyfourseven.zira.RatingSetScreen;
import com.twentyfourseven.zira.RiderRideView;
import com.twentyfourseven.zira.RiderRideView.AsyncTaskForGettingVehicle;

import com.zira.async_tasks.AsyncResponseForZira;
import com.zira.async_tasks.AsyncTaskForZira;
import com.zira.modal.GetTripDetails;
import com.zira.modal.MainVehicleModel;
import com.zira.util.ImageLoader;
import com.zira.util.SingleTon;
import com.zira.util.ZiraParser;

public class EndRideActivity extends Activity  implements LocationListener,AsyncResponseForZira {
	GoogleMap googleMap;
	//using current latlog and destination latlong of tripid 635 
	double curLongitude,curLatitude,destLongitude,destLatitude;
	private GetTripDetails mTripDetailsModel;
	
	LocationManager locationManager;
	Criteria criteria;
	String provider;
	SharedPreferences prefs;
	float totalKms =00,totalKmInMiles=00;
	private int distanceValue,timeValue,approxMinutes;
	private MainVehicleModel vehicleModel;
	String distance,time,myAddress;
	double tripStartLat,tripStartLong,tripdestinationLat,tripdestinationLong;
	String actualfare;
	int flagdis=0;
	String newactualf="";
	private ZiraParser parser;
	private  AsyncTaskForGettingVehicle mAsyncTask;
	private RelativeLayout profileLayout;
	private Button button_getdirection;
	String selectedDate;
	int flag=0;
	TextView textView_text,textViewWhoSendRequest;
	double longitude, latitude,myLat,myLon;
	String GetDetailsByTripId="GetDetailsByTripId";
	private GetTripDetails tripDetailsModal;
	RelativeLayout lay_imageandtext;
	private ImageLoader imageLoader;
	ImageView imageViewDriverImage;
@Override
protected void onCreate(Bundle savedInstanceState) {
	requestWindowFeature(Window.FEATURE_NO_TITLE);
	super.onCreate(savedInstanceState);
	setContentView(R.layout.activity_endride);
	
	mTripDetailsModel=SingleTon.getInstance().getGetTripDetail();
	prefs = getSharedPreferences("Zira", MODE_PRIVATE);
	parser =new ZiraParser();
	tripDetailsModal=new GetTripDetails();
	textViewWhoSendRequest=(TextView)findViewById(R.id.textViewWhoSendRequest);
	lay_imageandtext=(RelativeLayout)findViewById(R.id.lay_imageandtext);
	textViewWhoSendRequest.setText(prefs.getString("DriverName", ""));
	textView_text=(TextView)findViewById(R.id.textView_text);
	textView_text.setText(prefs.getString("driverMessage", ""));
	
	imageViewDriverImage=(ImageView)findViewById(R.id.imageViewDriverImage);
	imageLoader = new ImageLoader(EndRideActivity.this);
	imageLoader.DisplayImage(prefs.getString("driverImage", ""),imageViewDriverImage);
	lay_imageandtext.setOnClickListener(new View.OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			getDriverDetailByTripIDend();
		}
	});

	try {
		// Loading map
		initilizeMap();

	} catch (Exception e) {
		e.printStackTrace();
	}

}
private void getDriverDetailByTripIDend() {
	Editor ed=prefs.edit();
	ed.putString("tripid",prefs.getString("driverTripId", ""));
	ed.commit();
	ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(1);
	nameValuePairs.add(new BasicNameValuePair("TripId",prefs.getString("driverTripId", "")));
	Log.e("GetDetailsByTripId", nameValuePairs.toString());
	AsyncTaskForZira mFetchStates = new AsyncTaskForZira(EndRideActivity.this, GetDetailsByTripId,nameValuePairs, true, "Please wait");
	mFetchStates.delegate = (AsyncResponseForZira) EndRideActivity.this;
	mFetchStates.execute();		
}

/**
 * function to load map. If map is not created it will create it for you
 * */
private void initilizeMap() {
	if (googleMap == null) {
		try{
			prefs = getSharedPreferences("Zira", MODE_PRIVATE);
			curLatitude = Double.parseDouble(prefs.getString("tripstarttlat", ""));
			curLongitude = Double.parseDouble(prefs.getString("tripstartlong", ""));
			destLongitude = Double.parseDouble(prefs.getString("tripdestlong", ""));
			destLatitude = Double.parseDouble(prefs.getString("tripdestlat", ""));
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		googleMap = ((MapFragment) getFragmentManager().findFragmentById(R.id.rider_ride_map)).getMap();
		googleMap.setMyLocationEnabled(true);		
		googleMap.getUiSettings().setRotateGesturesEnabled(true);
		googleMap.getUiSettings().setZoomControlsEnabled(false);
		CameraPosition cameraPosition = new CameraPosition.Builder().target(new LatLng(curLatitude, curLongitude)).zoom(15).build();

		googleMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));

		
		placeMarker();
		
		
	
		LatLng curLatLng=new  LatLng(curLatitude, curLongitude);
		LatLng destLatLng=new  LatLng(destLatitude, destLongitude);
		
		Log.i("tag", "Longitude:"+curLongitude);
		Log.i("tag", "Latitude:"+curLongitude);
		Log.i("tag", "destLongitude:"+destLongitude);
		Log.i("tag", "destLatitude:"+destLatitude);
		
		String url = getDirectionsUrl(curLatLng, destLatLng);				 
		DownloadTask downloadTask = new DownloadTask();               
		downloadTask.execute(url);
		

		// check if map is created successfully or not
		if (googleMap == null) {
			Toast.makeText(getApplicationContext(),
					"Sorry! unable to create maps", Toast.LENGTH_SHORT)
					.show();
		}
		locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
		criteria = new Criteria();

		// Getting the name of the best provider
		provider = locationManager.getBestProvider(criteria, true);

		try {
			boolean enabledGPS = locationManager
					.isProviderEnabled(LocationManager.GPS_PROVIDER);
			boolean enabledWiFi = locationManager
					.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

			// Check if enabled and if not send user to the GSP settings
			if (!enabledGPS && !enabledWiFi) {
				Toast.makeText(EndRideActivity.this, "GPS signal not found",Toast.LENGTH_LONG).show();
				Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
				startActivity(intent);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		locationManager.requestLocationUpdates(provider, 15000, 0, this);
	}
}

@Override
protected void onResume() {
	super.onResume();
	initilizeMap();
}

// placing marker
public void placeMarker() {
	// create marker
	//MarkerOptions curLocationmarker = new MarkerOptions().position(new LatLng(curLatitude, curLongitude)).icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN));
	 // adding marker
	googleMap.addMarker(new MarkerOptions().position(new LatLng(curLatitude, curLongitude)).icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN)));
	
	MarkerOptions destLocationmarker = new MarkerOptions().position(new LatLng(destLatitude, destLongitude));
	 // adding marker
	googleMap.addMarker(destLocationmarker);
}
/**********Path Draw***********/
private String getDirectionsUrl(LatLng origin,LatLng dest){

	// Origin of route
	String str_origin = "origin="+origin.latitude+","+origin.longitude;

	// Destination of route
	String str_dest = "destination="+dest.latitude+","+dest.longitude;

	// Sensor enabled
	String sensor = "sensor=false";

	// Building the parameters to the web service
	String parameters = str_origin+"&"+str_dest+"&"+sensor;

	// Output format
	String output = "json";

	// Building the url to the web service
	String url = "https://maps.googleapis.com/maps/api/directions/"+output+"?"+parameters;

	Log.e("", url);

	return url;
}
/** A method to download json data from url */
private String downloadUrl(String strUrl) throws IOException{
	String data = "";
	InputStream iStream = null;
	HttpURLConnection urlConnection = null;
	try{
		URL url = new URL(strUrl);

		// Creating an http connection to communicate with url
		urlConnection = (HttpURLConnection) url.openConnection();

		// Connecting to url
		urlConnection.connect();

		// Reading data from url
		iStream = urlConnection.getInputStream();

		BufferedReader br = new BufferedReader(new InputStreamReader(iStream));

		StringBuffer sb = new StringBuffer();

		String line = "";
		while( ( line = br.readLine()) != null){
			sb.append(line);
		}

		data = sb.toString();

		br.close();

	}catch(Exception e){
		Log.d("Exception while downloading url", e.toString());
	}finally{
		iStream.close();
		urlConnection.disconnect();
	}
	return data;
}

// Fetches data from url passed
private class DownloadTask extends AsyncTask<String, Void, String>{

	// Downloading data in non-ui thread
	@Override
	protected String doInBackground(String... url) {

		// For storing data from web service
		String data = "";

		try{
			// Fetching the data from web service
			data = downloadUrl(url[0]);
		}catch(Exception e){
			Log.d("Background Task",e.toString());
		}
		return data;
	}

	// Executes in UI thread, after the execution of
	// doInBackground()
	@Override
	protected void onPostExecute(String result) {
		super.onPostExecute(result);

		ParserTask parserTask = new ParserTask();

		// Invokes the thread for parsing the JSON data
		parserTask.execute(result);
	}
}

/** A class to parse the Google Places in JSON format */
private class ParserTask extends AsyncTask<String, Integer, List<List<HashMap<String,String>>> >{

	// Parsing the data in non-ui thread
	@Override
	protected List<List<HashMap<String, String>>> doInBackground(String... jsonData) {

		JSONObject jObject;
		List<List<HashMap<String, String>>> routes = null;

		try{
			jObject = new JSONObject(jsonData[0]);
			DirectionsJSONParser parser = new DirectionsJSONParser();

			// Starts parsing data
			routes = parser.parse(jObject);
		}catch(Exception e){
			e.printStackTrace();
		}
		return routes;
	}

	// Executes in UI thread, after the parsing process
	@Override
	protected void onPostExecute(List<List<HashMap<String, String>>> result) {
		ArrayList<LatLng> points = null;
		PolylineOptions lineOptions = null;
		MarkerOptions markerOptions = new MarkerOptions();
			try{
		// Traversing through all the routes
		for(int i=0;i<result.size();i++){
			points = new ArrayList<LatLng>();
			lineOptions = new PolylineOptions();

			// Fetching i-th route
			List<HashMap<String, String>> path = result.get(i);

			// Fetching all the points in i-th route
			for(int j=0;j<path.size();j++){
				HashMap<String,String> point = path.get(j);

				double lat = Double.parseDouble(point.get("lat"));
				double lng = Double.parseDouble(point.get("lng"));
				LatLng position = new LatLng(lat, lng);

				points.add(position);
			}

			// Adding all the points in the route to LineOptions
			lineOptions.addAll(points);
			lineOptions.width(8);
			lineOptions.color(Color.RED);
		}

		// Drawing polyline in the Google Map for the i-th route
		googleMap.addPolyline(lineOptions);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
	}
}
public void onLocationChanged(Location location) {

	Log.e("in", "onlocationChanged");

	try {
		if (flag == 0) {
			flag = 1;
			myLat = location.getLatitude();

			// Getting longitude of the current location
			myLon = location.getLongitude();

			//getAddress(location, "start");
			Log.e("values", "lat : " + myLat + " , lon : " + myLon);

			// Creating a LatLng object for the current location
			LatLng latLng = new LatLng(myLat, myLon);

			// Showing the current location in Google Map
			googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(latLng,18));

			// Zoom in the Google Map
			googleMap.animateCamera(CameraUpdateFactory.zoomTo(15));
			//googleMap.addMarker(new MarkerOptions().position(new LatLng(myLat, myLon)).icon(BitmapDescriptorFactory.defaultMarker()));

			latitude = myLat;
			longitude =myLon;
		
			//getVehicleData();
		}

		else
		{
			//googleMap.clear();
			latitude = location.getLatitude();
			longitude = location.getLongitude();
			System.err.println("location update rider");
			LatLng latLng1 = new LatLng(latitude, longitude);
			googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(latLng1,15));
		
			}
	
			
			
	} catch (Exception e) {
		e.printStackTrace();
	}
	
}


public void onProviderDisabled(String provider) {
}
public void onProviderEnabled(String provider) {
}
public void onStatusChanged(String provider, int status, Bundle extras) {
}

@Override
public void processFinish(String output, String methodName) {
	JSONObject obj;
	String jsonResult1;
	try {
		obj = new JSONObject(output);
		String jsonMessage=obj.getString("message");
		jsonResult1=obj.getString("result");
//		Toast.makeText(RiderNotification.this, jsonMessage, 0).show();
		
		if(methodName.equals(GetDetailsByTripId)){
			if(jsonResult1.equals("0")){
				mTripDetailsModel = parser.parsegetTripDetails(output);
				SingleTon.getInstance().setGetTripDetail(mTripDetailsModel);
				Log.e("mTripDetailsModel", output);
				
				if(flag==1)
				{
					 String newactualf=mTripDetailsModel.getGetTrip_Trip_Total_amount();
					 try{
					
						 actualfare=new DecimalFormat("##.##").format(Float.parseFloat(newactualf));
					 }
					 catch(Exception e)
					 {
						e.printStackTrace(); 
					 }
					System.err.println("newactualf"+actualfare);
					Intent i=new Intent(EndRideActivity.this,RatingSetScreen.class);
					i.putExtra("newfare", actualfare);
					startActivity(i);
					finish();
				}
			}
		}
	}catch(Exception exception){
		exception.printStackTrace();
	}




}

@Override
public void onBackPressed() {
	moveTaskToBack(true);
}}