package com.maycur.plugin;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;

public class ImageViewerActivity extends FragmentActivity {

    private ViewPager mPager;
    private PagerAdapter mPagerAdapter;
    private String[] mUrls;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(getResources().getIdentifier("activity_image_viewer", "layout", getPackageName()));

        mUrls = getIntent().getExtras().getStringArray("extra_urls");
        int index = getIntent().getIntExtra("extra_index", 0);

        mPager = (ViewPager) findViewById(getResources().getIdentifier("pager", "id", getPackageName()));
        mPagerAdapter = new ImageViewerAdapter(getSupportFragmentManager());
        mPager.setAdapter(mPagerAdapter);
        mPager.setCurrentItem(index);
    }

    private class ImageViewerAdapter extends FragmentStatePagerAdapter {
        public ImageViewerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            return ImagePageFragment.newInstance(mUrls[position]);
        }

        @Override
        public int getCount() {
            return mUrls.length;
        }
    }
}
