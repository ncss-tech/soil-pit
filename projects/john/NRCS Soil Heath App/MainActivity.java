package com.nrcssoilhealth;

import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.ActionBar.TabListener;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.SimpleOnPageChangeListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;

public class MainActivity
  extends FragmentActivity
  implements ActionBar.TabListener
{
  AppSectionsPagerAdapter mAppSectionsPagerAdapter;
  ViewPager mViewPager;
  
  public void onCreate(final Bundle paramBundle)
  {
    super.onCreate(paramBundle);
    setContentView(2130903041);
    this.mAppSectionsPagerAdapter = new AppSectionsPagerAdapter(getSupportFragmentManager());
    paramBundle = getActionBar();
    paramBundle.setHomeButtonEnabled(false);
    paramBundle.setNavigationMode(2);
    this.mViewPager = ((ViewPager)findViewById(2131296256));
    this.mViewPager.setAdapter(this.mAppSectionsPagerAdapter);
    this.mViewPager.setOnPageChangeListener(new ViewPager.SimpleOnPageChangeListener()
    {
      public void onPageSelected(int paramAnonymousInt)
      {
        paramBundle.setSelectedNavigationItem(paramAnonymousInt);
      }
    });
    int i = 0;
    for (;;)
    {
      if (i >= this.mAppSectionsPagerAdapter.getCount()) {
        return;
      }
      paramBundle.addTab(paramBundle.newTab().setText(this.mAppSectionsPagerAdapter.getPageTitle(i)).setTabListener(this));
      i += 1;
    }
  }
  
  public void onTabReselected(ActionBar.Tab paramTab, FragmentTransaction paramFragmentTransaction) {}
  
  public void onTabSelected(ActionBar.Tab paramTab, FragmentTransaction paramFragmentTransaction)
  {
    this.mViewPager.setCurrentItem(paramTab.getPosition());
  }
  
  public void onTabUnselected(ActionBar.Tab paramTab, FragmentTransaction paramFragmentTransaction) {}
  
  public static class AppSectionsPagerAdapter
    extends FragmentPagerAdapter
  {
    public AppSectionsPagerAdapter(FragmentManager paramFragmentManager)
    {
      super();
    }
    
    public int getCount()
    {
      return 3;
    }
    
    public Fragment getItem(int paramInt)
    {
      switch (paramInt)
      {
      default: 
        MainActivity.DummySectionFragment localDummySectionFragment = new MainActivity.DummySectionFragment();
        Bundle localBundle = new Bundle();
        localBundle.putInt("section_number", paramInt + 1);
        localDummySectionFragment.setArguments(localBundle);
        return localDummySectionFragment;
      case 0: 
        return new MainActivity.LaunchpadSectionFragment();
      case 1: 
        return new MainActivity.VideoSectionFragment();
      }
      return new MainActivity.DocumentSectionFragment();
    }
    
    public CharSequence getPageTitle(int paramInt)
    {
      switch (paramInt)
      {
      default: 
        return "Group";
      case 0: 
        return "Quiz";
      case 1: 
        return "Videos";
      }
      return "Documents";
    }
  }
  
  public static class DocumentSectionFragment
    extends Fragment
  {
    public View onCreateView(LayoutInflater paramLayoutInflater, ViewGroup paramViewGroup, Bundle paramBundle)
    {
      return paramLayoutInflater.inflate(2130903049, paramViewGroup, false);
    }
  }
  
  public static class DummySectionFragment
    extends Fragment
  {
    public static final String ARG_SECTION_NUMBER = "section_number";
    
    public View onCreateView(LayoutInflater paramLayoutInflater, ViewGroup paramViewGroup, Bundle paramBundle)
    {
      paramLayoutInflater = paramLayoutInflater.inflate(2130903050, paramViewGroup, false);
      paramViewGroup = getArguments();
      ((TextView)paramLayoutInflater.findViewById(16908308)).setText(getString(2131034120, new Object[] { Integer.valueOf(paramViewGroup.getInt("section_number")) }));
      return paramLayoutInflater;
    }
  }
  
  public static class LaunchpadSectionFragment
    extends Fragment
  {
    public View onCreateView(LayoutInflater paramLayoutInflater, ViewGroup paramViewGroup, Bundle paramBundle)
    {
      paramLayoutInflater = paramLayoutInflater.inflate(2130903051, paramViewGroup, false);
      paramLayoutInflater.findViewById(2131296275).setOnClickListener(new View.OnClickListener()
      {
        public void onClick(View paramAnonymousView)
        {
          paramAnonymousView = new Intent(MainActivity.LaunchpadSectionFragment.this.getActivity(), CollectionActivity.class);
          MainActivity.LaunchpadSectionFragment.this.startActivity(paramAnonymousView);
        }
      });
      paramLayoutInflater.findViewById(2131296276).setOnClickListener(new View.OnClickListener()
      {
        public void onClick(View paramAnonymousView)
        {
          paramAnonymousView = new Intent("android.intent.action.PICK");
          paramAnonymousView.setType("image/*");
          paramAnonymousView.addFlags(524288);
          MainActivity.LaunchpadSectionFragment.this.startActivity(paramAnonymousView);
        }
      });
      return paramLayoutInflater;
    }
  }
  
  public static class VideoSectionFragment
    extends Fragment
  {
    public View onCreateView(LayoutInflater paramLayoutInflater, ViewGroup paramViewGroup, Bundle paramBundle)
    {
      return paramLayoutInflater.inflate(2130903052, paramViewGroup, false);
    }
  }
}


/* Location:              C:\Users\John\Desktop\java\classes-dex2jar.jar!\com\nrcssoilhealth\MainActivity.class
 * Java compiler version: 6 (50.0)
 * JD-Core Version:       0.7.1
 */