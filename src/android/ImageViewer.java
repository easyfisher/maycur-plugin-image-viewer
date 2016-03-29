package com.maycur.plugin;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class ImageViewer extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("show")) {
            JSONArray array = args.getJSONArray(0);
            int index = args.getInt(1);
            if (array.length() <= 0) {
                return false;
            }

            if (index < 0) {
                index = 0;
            } else if (index >= array.length()) {
                index = array.length() - 1;
            }

            String[] urls = new String[array.length()];
            for (int i = 0; i < array.length(); i++) {
                urls[i] = array.getString(i);
            }

            this.show(urls, index);
            return true;
        }
        return false;
    }

    private void show(final String[] urls, final int index) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Context context = cordova.getActivity()
                        .getApplicationContext();
                Intent intent = new Intent(context, ImageViewerActivity.class);
                Bundle extras = new Bundle();
                intent.putExtra("extra_index", index);
                extras.putStringArray("extra_urls", urls);
                intent.putExtras(extras);
                cordova.getActivity().startActivity(intent);
            }
        });
    }
}
