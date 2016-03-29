package com.maycur.plugin;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;

import com.ionicframework.myapp543873.R;

import java.io.InputStream;

/**
 * Created by Easter on 16/3/29.
 */
public class ImagePageFragment extends Fragment {

    private static final String PARAM_URL = "param_url";

    public static ImagePageFragment newInstance(String url) {
        ImagePageFragment fragment = new ImagePageFragment();
        Bundle arguments = new Bundle();
        arguments.putString(PARAM_URL, url);
        fragment.setArguments(arguments);
        return fragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        ViewGroup rootView = (ViewGroup) inflater.inflate(R.layout.fragment_image_page, container, false);
        rootView.findViewById(R.id.lyt_content).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getActivity().finish();
            }
        });
        ImageView imageView = (ImageView) rootView.findViewById(R.id.iv_content);
        ProgressBar indicator = (ProgressBar) rootView.findViewById(R.id.pb_loading);
        indicator.getIndeterminateDrawable().setColorFilter(0xffdddddd, android.graphics.PorterDuff.Mode.MULTIPLY);
        Bundle arguments = getArguments();
        if (arguments != null) {
            String url = arguments.getString(PARAM_URL);
            new DownloadImageTask(imageView, indicator).execute(url);
        }

        return rootView;
    }
}

class DownloadImageTask extends AsyncTask<String, Void, Bitmap> {
    ImageView mImageView;
    ProgressBar mIndicator;

    public DownloadImageTask(ImageView image, ProgressBar indicator) {
        mImageView = image;
        mIndicator = indicator;
    }

    protected Bitmap doInBackground(String... urls) {
        String urldisplay = urls[0];
        Bitmap bitmap = null;
        try {
            InputStream in = new java.net.URL(urldisplay).openStream();
            bitmap = BitmapFactory.decodeStream(in);
        } catch (Exception e) {
            Log.e("Error", e.getMessage());
        }
        return bitmap;
    }

    protected void onPostExecute(Bitmap result) {
        mImageView.setImageBitmap(result);
        mIndicator.setVisibility(View.GONE);
    }
}
