package com.twentyfourseven.zira;

import java.text.DecimalFormat;

import com.zira.modal.GetTripDetails;
import com.zira.util.SingleTon;
import com.zira.util.Util;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

public class TipView extends Activity{
	TextView showFare,totalFare;
	EditText edit_tip;
	TextView btn_Done,btn_NoTip;
	float tip;
	private GetTripDetails tripDetailsModel;
	SharedPreferences prefs;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_tipiview);
		intailizeVariables();
		clickListner();

	}
	private void intailizeVariables()
	{
		prefs=getSharedPreferences("Zira", MODE_PRIVATE);	
		tripDetailsModel=SingleTon.getInstance().getGetTripDetail();
		showFare=(TextView)findViewById(R.id.txt_showFare);
		totalFare=(TextView)findViewById(R.id.textViewTotalFare);
		edit_tip=(EditText)findViewById(R.id.edt_enterTip);
		btn_Done=(TextView)findViewById(R.id.btn_Done);
		btn_NoTip=(TextView)findViewById(R.id.btn_NoTip);
	/*	String newFare=new DecimalFormat("##.##").format(Float.parseFloat(tripDetailsModel.getGetTrip_SuggesstionFare()));
		showFare.setText(newFare);*/
		//////////////////////
		showFare.setText(""+	 getIntent().getStringExtra("newfare"));
		totalFare.setText(showFare.getText().toString());
		
		totalFare.setText(showFare.getText().toString());
		
	}
	private void clickListner() {
		
		edit_tip.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				// TODO Auto-generated method stub
				try{
				float gettingFare=Float.parseFloat(showFare.getText().toString());
				String  gettingTip=edit_tip.getText().toString();
				if(gettingTip.equals("")){
					tip=Float.parseFloat("0.0");
				}else{
					tip=Float.parseFloat(edit_tip.getText().toString());	
				}
				float result=gettingFare+tip;
				totalFare.setText(String.valueOf(result));
				}
				catch(Exception e)
				{
					
				}
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
				// TODO Auto-generated method stub

			}

			@Override
			public void afterTextChanged(Editable s) {
				// TODO Auto-generated method stub

			}
		});
		btn_Done.setOnClickListener(new OnClickListener() {
		public void onClick(View v) {
				// TODO Auto-generated method stub
				if(edit_tip.getText().toString().equals(""))
				{
					Util.alertMessage(TipView.this, "Please enter Tip amount");
				}
				else{
				String saveTipForUsingNextScreen=edit_tip.getText().toString();
				Editor ed=prefs.edit();
				ed.putString("triptip", saveTipForUsingNextScreen);
				ed.putString("triptotalfare", totalFare.getText().toString().trim());
				ed.commit();
				//SingleTon.getInstance().setTip(saveTipForUsingNextScreen);
				//SingleTon.getInstance().setTotalFare(totalFare.getText().toString().trim());
				startActivity(new Intent(TipView.this,SplitFare.class));
				finish();
				}
			}
		});
		btn_NoTip.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
					// TODO Auto-generated method stub
					
					//String saveTipForUsingNextScreen=edit_tip.getText().toString();
					Editor ed=prefs.edit();
					ed.putString("triptip", "0");
					ed.putString("triptotalfare", totalFare.getText().toString().trim());
					ed.commit();
					//SingleTon.getInstance().setTip(saveTipForUsingNextScreen);
					//SingleTon.getInstance().setTotalFare(totalFare.getText().toString().trim());
					startActivity(new Intent(TipView.this,SplitFare.class));
					finish();
					
				}
			});
	}
	@Override
	public void onBackPressed() {
		// TODO Auto-generated method stub
		super.onBackPressed();
		edit_tip.setText("");
	}
}
