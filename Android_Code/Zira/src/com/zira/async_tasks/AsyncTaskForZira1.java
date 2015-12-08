package com.zira.async_tasks;


import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.http.NameValuePair;
import org.apache.http.ParseException;
import org.json.JSONObject;

import com.twentyfourseven.zira.R;
import com.zira.registration.AddCreditInfo;
import com.zira.registration.DocumentUploadActivity;
import com.zira.util.Util;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.res.Resources.NotFoundException;
import android.os.AsyncTask;
import android.util.Log;

public class AsyncTaskForZira1 extends AsyncTask<String, Void, String> {

	private Activity activity;
	public AsyncResponseForZira1 delegate = null;
	private String result = "",imagepath;	
	private  ProgressDialog pDialog;
	private String methodName, message;
	private Map<String, String> nameValuePairs;
	private boolean displayProgress;
	
//	public AsyncTaskForZira1(AddCreditInfo addCreditInfo,String uploadImageMethod, Map<String, String> params,
//			boolean displayDialog, String message, String encodedImage) {
//		// TODO Auto-generated constructor stub
//		
//		this.activity = addCreditInfo;
//		this.methodName = uploadImageMethod;
//		this.nameValuePairs = params;
//		this.displayProgress = displayDialog;
//		this.message = message;
//		this.imagepath=encodedImage;
//	}

	public AsyncTaskForZira1(AddCreditInfo addCreditInfo,String uploadImageMethod, Map<String, String> params,boolean displayDialog,String message, String encodedImage) {
		// TODO Auto-generated constructor stub
		this.activity = addCreditInfo;
		this.methodName = uploadImageMethod;
		this.nameValuePairs = params;
		this.displayProgress = displayDialog;
		this.message = message;
		this.imagepath=encodedImage;
	}

	@Override
	protected void onPreExecute() {
		// TODO Auto-generated method stub
		super.onPreExecute();

		if(displayProgress){
			pDialog = new ProgressDialog(activity);
			pDialog.setTitle("Zira 24/7");
			pDialog.setMessage(message);
			pDialog.setCancelable(false);
			pDialog.show();
		}
	}

	@Override
	protected String doInBackground(String... urls) {
		try {
			
			//result =multipartRequest(activity.getResources().getString(R.string.baseUrl)+"/"+methodName,nameValuePairs, imagepath);
			result=upload(activity.getResources().getString(R.string.baseUrl)+"/"+methodName, imagepath,	nameValuePairs);
		Log.d("","resultresult"+result);
		Log.d("","resultresult"+result);
		Log.d("","resultresult"+result);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

	@Override
	protected void onPostExecute(String result) {
		// TODO Auto-generated method stub
		super.onPostExecute(result);
		
		try{
		if(displayProgress)
	
		 pDialog.dismiss();
		
		
		delegate.processFinish(result, methodName);
		}
		catch (Exception e) {
			System.err.println("dailog exception="+e);
		}
		
		
	}
//	public String multipartRequest(String urlTo, Map<String,String> nameValuePairs, String imagepath) throws ParseException, IOException  {
//        HttpURLConnection connection = null;
//        DataOutputStream outputStream = null;
//        InputStream inputStream = null;
//
//        Log.d("","urlTo"+urlTo);
//        Log.d("","urlTo"+urlTo);
//        Log.d("","imagepath"+imagepath);
//        Log.d("","imagepath"+imagepath);
//        String twoHyphens = "--";
//        String boundary = "*****" + Long.toString(System.currentTimeMillis()) + "*****";
//        String lineEnd = "\r\n";
//
//        String result = "";
//
//        int bytesRead, bytesAvailable, bufferSize;
//        byte[] buffer;
//        int maxBufferSize = 1 * 1024 * 1024;
//
//        String[] q = imagepath.split("/");
//        int idx = q.length - 1;
//
//        try {
//            File file = new File(imagepath);
//            FileInputStream fileInputStream = new FileInputStream(file);
//
//            URL url = new URL(urlTo);
//            connection = (HttpURLConnection) url.openConnection();
//
//            connection.setDoInput(true);
//            connection.setDoOutput(true);
//            connection.setUseCaches(false);
//
//            connection.setRequestMethod("POST");
//            connection.setRequestProperty("Connection", "Keep-Alive");
//            connection.setRequestProperty("User-Agent", "Android Multipart HTTP Client 1.0");
//            connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
//
//            //outputStream = new DataOutputStream(connection.getOutputStream());
//            outputStream = new DataOutputStream(connection.getOutputStream());
//			outputStream.writeBytes(twoHyphens + boundary + lineEnd);
//			outputStream.writeBytes("Content-Disposition: form-data;filename=\"" + q[idx] +"\"" + lineEnd);
//			outputStream.writeBytes("Content-Type: image/jpeg" + lineEnd);
//			outputStream.writeBytes("Content-Transfer-Encoding: binary" + lineEnd);
//			outputStream.writeBytes(lineEnd);
//			
//            //outputStream.writeBytes(lineEnd);
//
//            bytesAvailable = fileInputStream.available();
//            bufferSize = Math.min(bytesAvailable, maxBufferSize);
//            buffer = new byte[bufferSize];
//
//            bytesRead = fileInputStream.read(buffer, 0, bufferSize);
//            while (bytesRead > 0) {
//                outputStream.write(buffer, 0, bufferSize);
//                bytesAvailable = fileInputStream.available();
//                bufferSize = Math.min(bytesAvailable, maxBufferSize);
//                bytesRead = fileInputStream.read(buffer, 0, bufferSize);
//            }
//
//            outputStream.writeBytes(lineEnd);
//
//            // Upload POST Data
//            Iterator<String> keys = nameValuePairs.keySet().iterator();
//            while (keys.hasNext()) {
//                String key = keys.next();
//                String value = nameValuePairs.get(key);
//
//                outputStream.writeBytes(twoHyphens + boundary + lineEnd);
//                outputStream.writeBytes("Content-Disposition: form-data; name=\"" + key + "\"" + lineEnd);
//                outputStream.writeBytes("Content-Type: text/plain" + lineEnd);
//                outputStream.writeBytes(lineEnd);
//                outputStream.writeBytes(value);
//                outputStream.writeBytes(lineEnd);
//            }
//
//            outputStream.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);
//
//
//            if (200 != connection.getResponseCode()) {
//               // throw new CustomException("Failed to upload code:" + connection.getResponseCode() + " " + connection.getResponseMessage());
//            }
//
//            inputStream = connection.getInputStream();
//
//            result = this.convertStreamToString(inputStream);
//
//            fileInputStream.close();
//            inputStream.close();
//            outputStream.flush();
//            outputStream.close();
//
//            return result;
//        } catch (Exception e) {
//           // logger.error(e);
//            //throw new CustomException(e);
//        }
//		return result;
//
//    }

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
    
    
    public String multipartRequest(String urlTo, Map<String,String> nameValuePairs, String imagepath) throws ParseException, IOException {
		HttpURLConnection connection = null;
		DataOutputStream outputStream = null;
		InputStream inputStream = null;
		
		String twoHyphens = "--";
		String boundary =  "*****"+Long.toString(System.currentTimeMillis())+"*****";
		String lineEnd = "\r\n";
		
		String result = "";
		Log.d("","urlTo"+urlTo);
       Log.d("","urlTo"+urlTo);
       Log.d("","imagepath"+imagepath);
       Log.d("","imagepath"+imagepath);
		int bytesRead, bytesAvailable, bufferSize;
		byte[] buffer;
		int maxBufferSize = 1*1024*1024;
		
		String[] q = imagepath.split("/");
		int idx = q.length - 1;
		
		try {
			File file = new File(imagepath);
			FileInputStream fileInputStream = new FileInputStream(file);
			
			URL url = new URL(urlTo);
			connection = (HttpURLConnection) url.openConnection();
			
			connection.setDoInput(true);
			connection.setDoOutput(true);
			connection.setUseCaches(false);
			
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Connection", "Keep-Alive");
			connection.setRequestProperty("User-Agent", "Android Multipart HTTP Client 1.0");
			connection.setRequestProperty("Content-Type", "multipart/form-data; boundary="+boundary);
			
			outputStream = new DataOutputStream(connection.getOutputStream());
			outputStream.writeBytes(twoHyphens + boundary + lineEnd);
			outputStream.writeBytes("Content-Disposition: form-data;filename=\"" + q[idx] +"\"" + lineEnd);
			outputStream.writeBytes("Content-Type: image/jpeg" + lineEnd);
			outputStream.writeBytes("Content-Transfer-Encoding: binary" + lineEnd);
			outputStream.writeBytes(lineEnd);
			
			bytesAvailable = fileInputStream.available();
			bufferSize = Math.min(bytesAvailable, maxBufferSize);
			buffer = new byte[bufferSize];
			
			bytesRead = fileInputStream.read(buffer, 0, bufferSize);
			while(bytesRead > 0) {
				outputStream.write(buffer, 0, bufferSize);
				bytesAvailable = fileInputStream.available();
				bufferSize = Math.min(bytesAvailable, maxBufferSize);
				bytesRead = fileInputStream.read(buffer, 0, bufferSize);
			}
			
			outputStream.writeBytes(lineEnd);
			
			// Upload POST Data
//			String[] posts = nameValuePairs.split("&");
//			int max = posts.length;
//			for(int i=0; i<max;i++) {
//				outputStream.writeBytes(twoHyphens + boundary + lineEnd);
//				String[] kv = posts[i].split("=");
//				outputStream.writeBytes("Content-Disposition: form-data; name=\"" + kv[0] + "\"" + lineEnd);
//				outputStream.writeBytes("Content-Type: text/plain"+lineEnd);
//				outputStream.writeBytes(lineEnd);
//				outputStream.writeBytes(kv[1]);
//				outputStream.writeBytes(lineEnd);
//			}
			
			outputStream.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);
			
			inputStream = connection.getInputStream();
			result = this.convertStreamToString(inputStream);
			
			fileInputStream.close();
			inputStream.close();
			outputStream.flush();
			outputStream.close();
			
			return result;
		} catch(Exception e) {
			Log.e("MultipartRequest","Multipart Form Upload Error");
			e.printStackTrace();
			return "error";
		}
	}
//
//	private String convertStreamToString(InputStream is) {
//		BufferedReader reader = new BufferedReader(new InputStreamReader(is));
//		StringBuilder sb = new StringBuilder();
//
//		String line = null;
//		try {
//			while ((line = reader.readLine()) != null) {
//				sb.append(line);
//			}
//		} catch (IOException e) {
//			e.printStackTrace();
//		} finally {
//			try {
//				is.close();
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//		}
//		return sb.toString();
//	}
	
	
public String upload(String tourl, String fileParameterName,Map<String,String> parameters) throws IOException {
HttpURLConnection conn = null;
DataOutputStream dos = null;
DataInputStream dis = null;
FileInputStream fileInputStream = null;
HttpURLConnection connection = null;
DataOutputStream outputStream = null;
InputStream inputStream = null;
Log.d("","urlTo"+tourl);
Log.d("","urlTo"+tourl);
Log.d("","imagepath"+fileParameterName);
Log.d("","imagepath"+fileParameterName);
String twoHyphens = "--";
String boundary =  "*****"+Long.toString(System.currentTimeMillis())+"*****";
String lineEnd = "\r\n";
byte[] buffer;
int maxBufferSize = 20 * 1024;
int bytesRead, bytesAvailable, bufferSize;
String[] q = fileParameterName.split("/");
int idx = q.length - 1;
try {
//	// ------------------ CLIENT REQUEST
//	File file =new File(fileParameterName);
//	fileInputStream = new FileInputStream(file);
//
//	// open a URL connection to the Servlet
//	// Open a HTTP connection to the URL
//	URL url = new URL(tourl);
//	conn = (HttpURLConnection) url.openConnection();
//	// Allow Inputs
//	conn.setDoInput(true);
//	// Allow Outputs
//	conn.setDoOutput(true);
//	// Don't use a cached copy.
//	conn.setUseCaches(false);
//	// Use a post method.
//	conn.setRequestMethod("POST");
//	conn.setRequestProperty("Content-Type",
//			"multipart/form-data;boundary=" + boundary);
//
//	dos = new DataOutputStream(conn.getOutputStream());
//
//	dos.writeBytes(twoHyphens + boundary + lineEnd);
//	dos.writeBytes("Content-Disposition: form-data; name=\""
//			+ fileParameterName + "\"; filename=\"" + "picimage"
//			+ ".jpg" + "\"" + lineEnd);
//	dos.writeBytes("Content-Type:image/jpg" + lineEnd);
//	dos.writeBytes(lineEnd);
	File file = new File(fileParameterName);
	FileInputStream fileInputStream1 = new FileInputStream(file);

	URL url = new URL(tourl);
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

	bytesAvailable = fileInputStream1.available();
	bufferSize = Math.min(bytesAvailable, maxBufferSize);
	buffer = new byte[bufferSize];

	bytesRead = fileInputStream1.read(buffer, 0, bufferSize);
	while (bytesRead > 0) {
		outputStream.write(buffer, 0, bufferSize);
		bytesAvailable = fileInputStream1.available();
		bufferSize = Math.min(bytesAvailable, maxBufferSize);
		bytesRead = fileInputStream1.read(buffer, 0, bufferSize);
	}

	outputStream.writeBytes(lineEnd);
	
	
	
	
	// create a buffer of maximum size
	buffer = new byte[Math.min((int) file.length(), maxBufferSize)];
	int length;
	// read file and write it into form...
	while ((length = fileInputStream1.read(buffer)) != -1) {
		dos.write(buffer, 0, length);
	}

	for (String name : parameters.keySet()) {
		System.out.print("getting parametereee"+name);
		dos.writeBytes(lineEnd);
		dos.writeBytes(twoHyphens + boundary + lineEnd);
		dos.writeBytes("Content-Disposition: form-data; name=\"" + name
				+ "\"" + lineEnd);
		dos.writeBytes(lineEnd);
		System.out.print("getting parametereee"+parameters.get(name));
		dos.writeBytes(parameters.get(name));
	}

	// send multipart form data necessary after file data...
	dos.writeBytes(lineEnd);
	dos.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);
	dos.flush();
} finally {
	if (fileInputStream != null)
		fileInputStream.close();
	if (dos != null)
		dos.close();
}

// ------------------ read the SERVER RESPONSE
try {
	dis = new DataInputStream(conn.getInputStream());
	StringBuilder response = new StringBuilder();

	String line;
	while ((line = dis.readLine()) != null) {
		response.append(line).append('\n');
	}

	System.out.println("Upload file responce:" + response.toString());
	return response.toString();
} finally {
	if (dis != null)
		dis.close();
}
}
//    public String multipartRequest(String urlTo, String post, String filepath, String filefield) throws ParseException, IOException {
//        HttpURLConnection connection = null;
//        DataOutputStream outputStream = null;
//        InputStream inputStream = null;
//        
//        String twoHyphens = "--";
//        String boundary =  "*****"+Long.toString(System.currentTimeMillis())+"*****";
//        String lineEnd = "\r\n";
//        
//        String result = "";
//        
//        int bytesRead, bytesAvailable, bufferSize;
//        byte[] buffer;
//        int maxBufferSize = 1*1024*1024;
//        
//        String[] q = filepath.split("/");
//        int idx = q.length - 1;
//        
//        try {
//                File file = new File(filepath);
//                FileInputStream fileInputStream = new FileInputStream(file);
//                
//                URL url = new URL(urlTo);
//                connection = (HttpURLConnection) url.openConnection();
//                
//                connection.setDoInput(true);
//                connection.setDoOutput(true);
//                connection.setUseCaches(false);
//                
//                connection.setRequestMethod("POST");
//                connection.setRequestProperty("Connection", "Keep-Alive");
//                connection.setRequestProperty("User-Agent", "Android Multipart HTTP Client 1.0");
//                connection.setRequestProperty("Content-Type", "multipart/form-data; boundary="+boundary);
//                
//                outputStream = new DataOutputStream(connection.getOutputStream());
//                outputStream.writeBytes(twoHyphens + boundary + lineEnd);
//                outputStream.writeBytes("Content-Disposition: form-data; name=\"" + filefield + "\"; filename=\"" + q[idx] +"\"" + lineEnd);
//                outputStream.writeBytes("Content-Type: image/jpeg" + lineEnd);
//                outputStream.writeBytes("Content-Transfer-Encoding: binary" + lineEnd);
//                outputStream.writeBytes(lineEnd);
//                
//                bytesAvailable = fileInputStream.available();
//                bufferSize = Math.min(bytesAvailable, maxBufferSize);
//                buffer = new byte[bufferSize];
//                
//                bytesRead = fileInputStream.read(buffer, 0, bufferSize);
//                while(bytesRead > 0) {
//                        outputStream.write(buffer, 0, bufferSize);
//                        bytesAvailable = fileInputStream.available();
//                        bufferSize = Math.min(bytesAvailable, maxBufferSize);
//                        bytesRead = fileInputStream.read(buffer, 0, bufferSize);
//                }
//                
//                outputStream.writeBytes(lineEnd);
//                
//                // Upload POST Data
//                String[] posts = post.split("&");
//                int max = posts.length;
//                for(int i=0; i<max;i++) {
//                        outputStream.writeBytes(twoHyphens + boundary + lineEnd);
//                        String[] kv = posts[i].split("=");
//                        outputStream.writeBytes("Content-Disposition: form-data; name=\"" + kv[0] + "\"" + lineEnd);
//                        outputStream.writeBytes("Content-Type: text/plain"+lineEnd);
//                        outputStream.writeBytes(lineEnd);
//                        outputStream.writeBytes(kv[1]);
//                        outputStream.writeBytes(lineEnd);
//                }
//                
//                outputStream.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);
//                
//                inputStream = connection.getInputStream();
//                result = this.convertStreamToString(inputStream);
//                
//                fileInputStream.close();
//                inputStream.close();
//                outputStream.flush();
//                outputStream.close();
//                
//                return result;
//        } catch(Exception e) {
//                Log.e("MultipartRequest","Multipart Form Upload Error");
//                e.printStackTrace();
//                return "error";
//        }
//}
//
//private String convertStreamToString(InputStream is) {
//        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
//        StringBuilder sb = new StringBuilder();
//
//        String line = null;
//        try {
//                while ((line = reader.readLine()) != null) {
//                        sb.append(line);
//                }
//        } catch (IOException e) {
//                e.printStackTrace();
//        } finally {
//                try {
//                        is.close();
//                } catch (IOException e) {
//                        e.printStackTrace();
//                }
//        }
//        return sb.toString();
//}
	
}
