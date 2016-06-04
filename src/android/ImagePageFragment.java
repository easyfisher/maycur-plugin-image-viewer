package com.maycur.plugin;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;

import com.davemorrissey.labs.subscaleview.ImageSource;
import com.davemorrissey.labs.subscaleview.SubsamplingScaleImageView;

import java.io.IOException;
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
        int rootId = getResources().getIdentifier("fragment_image_page", "layout", getActivity().getPackageName());
        ViewGroup rootView = (ViewGroup) inflater.inflate(rootId, container, false);
        SubsamplingScaleImageView imageView = (SubsamplingScaleImageView) rootView.findViewById(getResources().getIdentifier("iv_content", "id", getActivity().getPackageName()));
        imageView.setMaxScale(5);
        imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getActivity().finish();
            }
        });
        ProgressBar indicator = (ProgressBar) rootView.findViewById(getResources().getIdentifier("pb_loading", "id", getActivity().getPackageName()));
        indicator.getIndeterminateDrawable().setColorFilter(0xffdddddd, android.graphics.PorterDuff.Mode.MULTIPLY);
        Bundle arguments = getArguments();
        if (arguments != null) {
            String url = arguments.getString(PARAM_URL);
            if (url.startsWith("file:///")) {
                try {
                    Bitmap bitmap = MediaStore.Images.Media.getBitmap(getActivity().getContentResolver(), Uri.parse(url));
                    imageView.setImage(ImageSource.bitmap(bitmap));
                } catch (IOException e) {
                    Log.d("ImagePageFragment", "Invalid image uri");
                }

                indicator.setVisibility(View.GONE);
            } else {
                new DownloadImageTask(imageView, indicator).execute(url);
            }
        }

        return rootView;
    }
}


class DownloadImageTask extends AsyncTask<String, Void, Bitmap> {
    SubsamplingScaleImageView mImageView;
    ProgressBar mIndicator;

    public DownloadImageTask(SubsamplingScaleImageView image, ProgressBar indicator) {
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
        mImageView.setImage(ImageSource.bitmap(result));
        mIndicator.setVisibility(View.GONE);
    }
}
