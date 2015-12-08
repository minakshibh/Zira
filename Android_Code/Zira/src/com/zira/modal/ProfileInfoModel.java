package com.zira.modal;

import android.os.Parcel;
import android.os.Parcelable;

public class ProfileInfoModel  implements Parcelable { 

	private String userid, password,email,mobile,image,firstname,lastname,creditcardnumber;
	private String creditcardexpiry,creditcardcvv,address,address1,city,state,zipcode;
	private String drivinglicensenumber,drivinglicensestate,drivinglicenseexpirationdate;
	
	
	private String licenseplatenumber,licenseplatecountry,licenseplatestate,vechile_img_location;
	private String rc_img_location,license_img_location,medicalcertificate_img_location;
	private String vehicle_status,vechiletype,result,message,address2,rider_rating,driver_rating;
	
	private String dateofbirth,socialsecuritynumber,vechile_make,vechile_model,vechile_year;
	//edit code
	private String licenseplatestateID,licenseplatecountryID,vechile_modelID,drivinglicensestateID,stateID,PreferedVehicleType,cityID;

	
	public ProfileInfoModel() {
		// TODO Auto-generated constructor stub
	}
	

	private ProfileInfoModel(Parcel in) {
	
		
		this.userid = in.readString();
		this.password = in.readString();
		this.email = in.readString();
		
		this.mobile = in.readString();
		this.image = in.readString();
		this.firstname = in.readString();
		
		this.lastname = in.readString();
		this.creditcardnumber = in.readString();
		this.creditcardexpiry = in.readString();
		
		this.creditcardcvv = in.readString();
		this.address = in.readString();
		this.address1 = in.readString();
		
		this.city = in.readString();
		this.state = in.readString();
		this.zipcode = in.readString();
		
		this.drivinglicensenumber = in.readString();
		this.drivinglicensestate = in.readString();
		this.drivinglicenseexpirationdate = in.readString();
		
		this.licenseplatenumber = in.readString();
		this.licenseplatecountry = in.readString();
		this.licenseplatestate = in.readString();
		
	
		
		this.vechile_img_location = in.readString();
		this.rc_img_location = in.readString();
		this.license_img_location = in.readString();
		
		this.medicalcertificate_img_location = in.readString();
		this.vehicle_status = in.readString();
		this.vechiletype = in.readString();
		
		this.dateofbirth = in.readString();
		this.socialsecuritynumber = in.readString();
		
		this.vechile_make = in.readString();
		this.vechile_model = in.readString();
		this.vechile_year = in.readString();
		
		//dateofbirth,socialsecuritynumber,vechile_make,vechile_model,vechile_year;
	}
	
	
	public String getUserid() {
		return userid;
	}





	public void setUserid(String userid) {
		this.userid = userid;
	}





	public String getPassword() {
		return password;
	}





	public void setPassword(String password) {
		this.password = password;
	}





	public String getEmail() {
		return email;
	}





	public void setEmail(String email) {
		this.email = email;
	}





	public String getMobile() {
		return mobile;
	}





	public void setMobile(String mobile) {
		this.mobile = mobile;
	}





	public String getImage() {
		return image;
	}





	public void setImage(String image) {
		this.image = image;
	}





	public String getFirstname() {
		return firstname;
	}





	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}





	public String getLastname() {
		return lastname;
	}





	public void setLastname(String lastname) {
		this.lastname = lastname;
	}





	public String getCreditcardnumber() {
		return creditcardnumber;
	}





	public void setCreditcardnumber(String creditcardnumber) {
		this.creditcardnumber = creditcardnumber;
	}





	public String getCreditcardexpiry() {
		return creditcardexpiry;
	}





	public void setCreditcardexpiry(String creditcardexpiry) {
		this.creditcardexpiry = creditcardexpiry;
	}





	public String getCreditcardcvv() {
		return creditcardcvv;
	}





	public void setCreditcardcvv(String creditcardcvv) {
		this.creditcardcvv = creditcardcvv;
	}





	public String getAddress() {
		return address;
	}





	public void setAddress(String address) {
		this.address = address;
	}





	public String getAddress1() {
		return address1;
	}





	public void setAddress1(String address1) {
		this.address1 = address1;
	}





	public String getAddress2() {
		return address2;
	}





	public void setAddress2(String address2) {
		this.address2 = address2;
	}





	public String getCity() {
		return city;
	}





	public void setCity(String city) {
		this.city = city;
	}





	public String getState() {
		return state;
	}





	public void setState(String state) {
		this.state = state;
	}





	public String getZipcode() {
		return zipcode;
	}





	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}





	public String getDrivinglicensenumber() {
		return drivinglicensenumber;
	}





	public void setDrivinglicensenumber(String drivinglicensenumber) {
		this.drivinglicensenumber = drivinglicensenumber;
	}





	public String getDrivinglicensestate() {
		return drivinglicensestate;
	}





	public void setDrivinglicensestate(String drivinglicensestate) {
		this.drivinglicensestate = drivinglicensestate;
	}





	public String getDrivinglicenseexpirationdate() {
		return drivinglicenseexpirationdate;
	}





	public void setDrivinglicenseexpirationdate(String drivinglicenseexpirationdate) {
		this.drivinglicenseexpirationdate = drivinglicenseexpirationdate;
	}





	public String getDateofbirth() {
		return dateofbirth;
	}





	public void setDateofbirth(String dateofbirth) {
		this.dateofbirth = dateofbirth;
	}





	public String getSocialsecuritynumber() {
		return socialsecuritynumber;
	}





	public void setSocialsecuritynumber(String socialsecuritynumber) {
		this.socialsecuritynumber = socialsecuritynumber;
	}





	public String getVechile_make() {
		return vechile_make;
	}





	public void setVechile_make(String vechile_make) {
		this.vechile_make = vechile_make;
	}





	public String getVechile_model() {
		return vechile_model;
	}





	public void setVechile_model(String vechile_model) {
		this.vechile_model = vechile_model;
	}





	public String getVechile_year() {
		return vechile_year;
	}





	public void setVechile_year(String vechile_year) {
		this.vechile_year = vechile_year;
	}





	public String getLicenseplatenumber() {
		return licenseplatenumber;
	}





	public void setLicenseplatenumber(String licenseplatenumber) {
		this.licenseplatenumber = licenseplatenumber;
	}





	public String getLicenseplatecountry() {
		return licenseplatecountry;
	}





	public void setLicenseplatecountry(String licenseplatecountry) {
		this.licenseplatecountry = licenseplatecountry;
	}





	public String getLicenseplatestate() {
		return licenseplatestate;
	}





	public void setLicenseplatestate(String licenseplatestate) {
		this.licenseplatestate = licenseplatestate;
	}





	public String getVechile_img_location() {
		return vechile_img_location;
	}





	public void setVechile_img_location(String vechile_img_location) {
		this.vechile_img_location = vechile_img_location;
	}





	public String getRc_img_location() {
		return rc_img_location;
	}





	public void setRc_img_location(String rc_img_location) {
		this.rc_img_location = rc_img_location;
	}





	public String getLicense_img_location() {
		return license_img_location;
	}





	public void setLicense_img_location(String license_img_location) {
		this.license_img_location = license_img_location;
	}





	public String getMedicalcertificate_img_location() {
		return medicalcertificate_img_location;
	}





	public void setMedicalcertificate_img_location(
			String medicalcertificate_img_location) {
		this.medicalcertificate_img_location = medicalcertificate_img_location;
	}





	public String getRider_rating() {
		return rider_rating;
	}





	public void setRider_rating(String rider_rating) {
		this.rider_rating = rider_rating;
	}





	public String getDriver_rating() {
		return driver_rating;
	}





	public void setDriver_rating(String driver_rating) {
		this.driver_rating = driver_rating;
	}





	public String getVehicle_status() {
		return vehicle_status;
	}





	public void setVehicle_status(String vehicle_status) {
		this.vehicle_status = vehicle_status;
	}





	public String getVechiletype() {
		return vechiletype;
	}





	public void setVechiletype(String vechiletype) {
		this.vechiletype = vechiletype;
	}





	public String getLicenseplatestateID() {
		return licenseplatestateID;
	}





	public void setLicenseplatestateID(String licenseplatestateID) {
		this.licenseplatestateID = licenseplatestateID;
	}





	public String getLicenseplatecountryID() {
		return licenseplatecountryID;
	}





	public void setLicenseplatecountryID(String licenseplatecountryID) {
		this.licenseplatecountryID = licenseplatecountryID;
	}





	public String getVechile_modelID() {
		return vechile_modelID;
	}





	public void setVechile_modelID(String vechile_modelID) {
		this.vechile_modelID = vechile_modelID;
	}





	public String getDrivinglicensestateID() {
		return drivinglicensestateID;
	}





	public void setDrivinglicensestateID(String drivinglicensestateID) {
		this.drivinglicensestateID = drivinglicensestateID;
	}





	public String getStateID() {
		return stateID;
	}





	public void setStateID(String stateID) {
		this.stateID = stateID;
	}





	public String getPreferedVehicleType() {
		return PreferedVehicleType;
	}





	public void setPreferedVehicleType(String preferedVehicleType) {
		PreferedVehicleType = preferedVehicleType;
	}





	public String getCityID() {
		return cityID;
	}





	public void setCityID(String cityID) {
		this.cityID = cityID;
	}





	public String getResult() {
		return result;
	}





	public void setResult(String result) {
		this.result = result;
	}





	public String getMessage() {
		return message;
	}





	public void setMessage(String message) {
		this.message = message;
	}





	public static Parcelable.Creator<ProfileInfoModel> getCreator() {
		return CREATOR;
	}





	
	
	
	
	
	@Override
	public int describeContents() {
		// TODO Auto-generated method stub
		return this.hashCode();
	}
	@Override
	public void writeToParcel(Parcel dest, int flags) {
		// TODO Auto-generated method stub
		
		
		dest.writeString(userid);
		dest.writeString(password);
		dest.writeString(email);
		
		dest.writeString(mobile);
		dest.writeString(image);
		dest.writeString(firstname);
		
		dest.writeString(lastname);
		dest.writeString(creditcardnumber);
		dest.writeString(creditcardexpiry);
		
		dest.writeString(creditcardcvv);
		dest.writeString(address);
		dest.writeString(address1);
		
		dest.writeString(city);
		dest.writeString(state);
		dest.writeString(zipcode);
		
		dest.writeString(drivinglicensenumber);
		dest.writeString(drivinglicensestate);
		dest.writeString(drivinglicenseexpirationdate);
		
		dest.writeString(licenseplatenumber);
		dest.writeString(licenseplatecountry);
		dest.writeString(licenseplatestate);
		
		dest.writeString(vechile_img_location);
		dest.writeString(rc_img_location);
		dest.writeString(license_img_location);
		
		dest.writeString(medicalcertificate_img_location);
		dest.writeString(vehicle_status);
		dest.writeString(vechiletype);
		
	
		
		dest.writeString(dateofbirth);
		dest.writeString(socialsecuritynumber);
		
		dest.writeString(vechile_make);
		dest.writeString(vechile_model);
		dest.writeString(vechile_year);
		
	}
	
	
	public static final Parcelable.Creator<ProfileInfoModel> CREATOR
	= new Parcelable.Creator<ProfileInfoModel>()
	{
	public ProfileInfoModel createFromParcel(Parcel in)
	{
		return new ProfileInfoModel(in);
	}
	
	public ProfileInfoModel[] newArray (int size)
	{
		return new ProfileInfoModel[size];
	}
	};
}
