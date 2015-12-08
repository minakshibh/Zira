package com.twentyfourseven.zira;

import java.util.ArrayList;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.net.Uri;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.Window;
import android.widget.MediaController;
import android.widget.VideoView;
import com.zira.async_tasks.AsyncResponseForZira;
import com.zira.async_tasks.AsyncTaskForZira;
import com.zira.login.LegalPolicyDailog;
import com.zira.modal.ProfileInfoModel;
import com.zira.modal.User;
import com.zira.util.SingleTon;
import com.zira.util.Util;
import com.zira.util.ZiraParser;

public class SplashScreen extends Activity implements AsyncResponseForZira {
	public static SharedPreferences prefs;
	VideoView videoView;
	MediaController mcontroller;
	private User user;
	private ZiraParser ziraParser;
	private String getUserVehicleProfile = "GetProfiles";
	private ProfileInfoModel mProfileInfoModel;
	private boolean isLogin;
	private int flag = 0;
	public static Context splashContext;
	public static boolean check = false;
	public static SharedPreferences prefs2;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.splash_screen);

		splashContext = SplashScreen.this;
		ziraParser = new ZiraParser();

		prefs = getSharedPreferences("Zira", MODE_PRIVATE);
		prefs2 = getSharedPreferences("policy", MODE_PRIVATE);
		String loginStatus = prefs.getString("_Login", "");

		videoView = (VideoView) findViewById(R.id.videoView);
		// mcontroller = new MediaController(SplashScreen.this);
		// mcontroller.setEnabled(false);
		Uri videourl = Uri.parse("android.resource://" + getPackageName() + "/"
				+ R.raw.splashvideo);
		videoView.setVideoURI(videourl);
		// mcontroller.setAnchorView(videoView);
		// videoView.setMediaController(mcontroller);
		videoView.start();
		videoView.setOnCompletionListener(new OnCompletionListener() {

			public void onCompletion(MediaPlayer mp) {

				if (flag == 1) {
					String mode = prefs.getString("mode", "");
					if (mode.equals("")) {
						Intent i = new Intent(SplashScreen.this,com.twentyfourseven.zira.LoginActivity.class);
						startActivity(i);
						finish();
					} else if (mode.equals("driver")) {
						startActivity(new Intent(SplashScreen.this,DriverModeActivity.class));
						finish();
					} else if (mode.equals("rider")) {

						String getUserid = prefs.getString("Userid", "");
						if (getUserid.equals("")) {
							startActivity(new Intent(SplashScreen.this,com.twentyfourseven.zira.LoginActivity.class));
							finish();
						} else {
							Intent i = new Intent(SplashScreen.this,VehicleSearchActivity.class);
							i.putExtra("legalpolicy", "no");
							startActivity(i);
						}
					}
				} 
				else {
					videoView.start();
				}
			}
		});

		if (loginStatus.equals("true")) {
			isLogin = true;

			if (Util.isNetworkAvailable(SplashScreen.this)) {

				ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(
						1);
				nameValuePairs.add(new BasicNameValuePair("useremail", prefs
						.getString("_UserEmail", "")));
				nameValuePairs.add(new BasicNameValuePair("password", prefs
						.getString("_Password", "")));
				nameValuePairs.add(new BasicNameValuePair("UserDevicename",
						getUUID()));

				Log.e("splash", nameValuePairs.toString());
				AsyncTaskForZira mWebPageTask = new AsyncTaskForZira(
						SplashScreen.this, "Login", nameValuePairs, false, "");
				mWebPageTask.delegate = (AsyncResponseForZira) SplashScreen.this;
				mWebPageTask.execute();
			} else {
				alertMessage("Please check your internet connection");
			}
		} else {
			isLogin = false;
			flag = 1;
		}

	}

	@Override
	public void processFinish(String output, String methodName) {
		Log.e("login", output);
		if (methodName.equals("Login")) {

			user = ziraParser.parseLoginResponse(SplashScreen.this, output);
			try {
				if (user.getResult().equals("0")) {
					check=true;
					SingleTon.getInstance().setUser(user);
					try {
						ArrayList<NameValuePair> nameValuePair = new ArrayList<NameValuePair>(
								1);
						nameValuePair.add(new BasicNameValuePair("UserId", user.getUserid()));
						AsyncTaskForZira mWebPageTask = new AsyncTaskForZira(
								SplashScreen.this, getUserVehicleProfile,
								nameValuePair, false, "");
						mWebPageTask.delegate = (AsyncResponseForZira) SplashScreen.this;
						mWebPageTask.execute();
						Editor e = prefs.edit();
						e.putString("Userid", "yes");
						e.commit();
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else if(user.getMessage().contains("already logged")) {
					
					alertMessageForAlready(user.getMessage());
				
				}else
				{
					alertMessage(user.getMessage());
				
				}
			} catch (Exception e) {
				e.printStackTrace();
				AlertDialog.Builder alert = new AlertDialog.Builder(SplashScreen.this);
				alert.setTitle("Zira 24/7");
				alert.setMessage("Something went wrong. Please try again later.");
				alert.setPositiveButton("Ok",
						new DialogInterface.OnClickListener() {
							@Override
							public void onClick(DialogInterface dialog,
									int which) {
								finish();
							}
						});
				alert.show();

			}
		} else if (methodName.equals(getUserVehicleProfile)) {
			Log.e("getUserVehicleProfile", output);
			String result="1";
			mProfileInfoModel = ziraParser.profileInfo(output);
			result=mProfileInfoModel.getResult();
			
			if(result.equals("0"))
			{
				SingleTon.getInstance().setProfileInfoModel(mProfileInfoModel);
				check = true;
				ServerUtilities sUtil = new ServerUtilities();
				sUtil.deviceRegister(SplashScreen.this, mProfileInfoModel);
				goToNext();
				}
			else
			{
				AlertDialog.Builder alert = new AlertDialog.Builder(SplashScreen.this);
				alert.setTitle("Zira 24/7");
				alert.setMessage("Something went wrong. Please try again later.");
				alert.setPositiveButton("Ok",
						new DialogInterface.OnClickListener() {
							@Override
							public void onClick(DialogInterface dialog,int which) {
								
								Intent i = new Intent(SplashScreen.this, LoginActivity.class);
								startActivity(i);
								finish();
							}
						});
				alert.show();	
			}
		}
	}

	private String getUUID() {
		String uuids = "";
		TelephonyManager tManager = (TelephonyManager) this
				.getSystemService(Context.TELEPHONY_SERVICE);
		uuids = tManager.getDeviceId();
		return uuids;

	}

	public void alertMessage(String str) {

		AlertDialog.Builder alert = new AlertDialog.Builder(this);
		alert.setTitle("Zira 24/7");
		alert.setMessage(str);
		alert.setPositiveButton("ok", new DialogInterface.OnClickListener() {

			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				finish();
			}
		});

		alert.show();
	}
	public void alertMessageForAlready(String str) {

		AlertDialog.Builder alert = new AlertDialog.Builder(this);
		alert.setTitle("Zira 24/7");
		alert.setMessage(str);
		alert.setPositiveButton("ok", new DialogInterface.OnClickListener() {

			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				Intent i2 = new Intent(SplashScreen.this,LoginActivity.class);
				startActivity(i2);
				finish();
			}
		});

		alert.show();
	}

	public void goToNext() {
		String checkpolicy;
		try {
			String mode = prefs.getString("mode", "");
			System.err.println("modeeeeeeeeeeeeeeeeeeeee========" + mode);
			if (mode.equals("")) {
			

				if (check == false)
				{

					checkpolicy = LoginActivity.prefs2.getString("policy", "");
					if (checkpolicy.equals(""))// lpft=legal policy first time
												// show check
					{
						Editor e = LoginActivity.prefs2.edit();
						e.putString("policy", "fullfhg");// lpft=legal policy
															// first time show
															// check
						e.commit();
						String check1 = LoginActivity.prefs2.getString(
								"policy", "");
						System.err.println("check1check1check1" + check1);
						Intent intent = new Intent(SplashScreen.this,LegalPolicyDailog.class);
						finish();
						startActivity(intent);

					} 
					else {
						Intent i2 = new Intent(SplashScreen.this,VehicleSearchActivity.class);
						i2.putExtra("profile", mProfileInfoModel);
						startActivity(i2);
						finish();
					}
				}
				else
				{
					Intent i = new Intent(SplashScreen.this, LoginActivity.class);
					startActivity(i);
					finish();
				}
			} else if (mode.equals("driver")) {
				Intent i = new Intent(SplashScreen.this,DriverModeActivity.class);
				i.putExtra("profile", mProfileInfoModel);
				finish();
				startActivity(i);
			} else if (mode.equals("rider")) {

				Intent i = new Intent(SplashScreen.this,VehicleSearchActivity.class);
				i.putExtra("profile", mProfileInfoModel);
				startActivity(i);
				finish();

			}

		} catch (Exception e) {
			System.err.println("splash screen" + e);
		}
	}
}
