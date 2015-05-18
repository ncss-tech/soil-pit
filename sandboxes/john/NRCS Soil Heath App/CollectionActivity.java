package com.nrcssoilhealth;

import android.app.ActionBar;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.app.NavUtils;
import android.support.v4.app.TaskStackBuilder;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public class CollectionActivity
  extends FragmentActivity
{
  DemoCollectionPagerAdapter mDemoCollectionPagerAdapter;
  ViewPager mViewPager;
  private String[] myStringArray;
  
  public String[] getMyStringArray()
  {
    return this.myStringArray;
  }
  
  public void onCreate(Bundle paramBundle)
  {
    super.onCreate(paramBundle);
    setContentView(2130903040);
    this.mDemoCollectionPagerAdapter = new DemoCollectionPagerAdapter(getSupportFragmentManager());
    getActionBar().setDisplayHomeAsUpEnabled(true);
    this.mViewPager = ((ViewPager)findViewById(2131296256));
    this.mViewPager.setAdapter(this.mDemoCollectionPagerAdapter);
  }
  
  public boolean onOptionsItemSelected(MenuItem paramMenuItem)
  {
    switch (paramMenuItem.getItemId())
    {
    default: 
      return super.onOptionsItemSelected(paramMenuItem);
    }
    paramMenuItem = new Intent(this, MainActivity.class);
    if (NavUtils.shouldUpRecreateTask(this, paramMenuItem))
    {
      TaskStackBuilder.from(this).addNextIntent(paramMenuItem).startActivities();
      finish();
    }
    for (;;)
    {
      return true;
      NavUtils.navigateUpTo(this, paramMenuItem);
    }
  }
  
  public void setMyStringArray(String[] paramArrayOfString)
  {
    this.myStringArray = paramArrayOfString;
  }
  
  public static class DemoCollectionPagerAdapter
    extends FragmentStatePagerAdapter
  {
    public DemoCollectionPagerAdapter(FragmentManager paramFragmentManager)
    {
      super();
    }
    
    public int getCount()
    {
      return 22;
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
        return new CollectionActivity.QuizCollectionFragment1();
      case 1: 
        return new CollectionActivity.QuizCollectionFragment2();
      case 2: 
        return new CollectionActivity.QuizCollectionFragment3();
      }
      return new CollectionActivity.QuizCollectionFragment21();
    }
    
    public CharSequence getPageTitle(int paramInt)
    {
      switch (paramInt)
      {
      default: 
        return "Question";
      case 0: 
        return "Question 1";
      case 1: 
        return "Question 2";
      case 2: 
        return "Question 3";
      case 3: 
        return "Question 4";
      case 4: 
        return "Question 5";
      case 5: 
        return "Question 6";
      case 6: 
        return "Question 7";
      case 7: 
        return "Question 8";
      case 8: 
        return "Question 9";
      case 9: 
        return "Question 10";
      case 10: 
        return "Question 11";
      case 11: 
        return "Question 12";
      case 12: 
        return "Question 13";
      case 13: 
        return "Question 14";
      case 14: 
        return "Question 15";
      case 15: 
        return "Question 16";
      case 16: 
        return "Question 17";
      case 17: 
        return "Question 18";
      case 18: 
        return "Question 19";
      case 19: 
        return "Question 20";
      case 20: 
        return "Review Answers";
      }
      return "Submit Quiz";
    }
  }
  
  public static class DemoObjectFragment
    extends Fragment
  {
    public static final String ARG_OBJECT = "Quiz";
    
    public View onCreateView(LayoutInflater paramLayoutInflater, ViewGroup paramViewGroup, Bundle paramBundle)
    {
      paramLayoutInflater = paramLayoutInflater.inflate(2130903042, paramViewGroup, false);
      paramViewGroup = getArguments();
      ((TextView)paramLayoutInflater.findViewById(16908308)).setText(Integer.toString(paramViewGroup.getInt("Quiz")));
      return paramLayoutInflater;
    }
  }
  
  public static class QuizCollectionFragment1
    extends Fragment
  {
    public View onCreateView(LayoutInflater paramLayoutInflater, ViewGroup paramViewGroup, Bundle paramBundle)
    {
      return paramLayoutInflater.inflate(2130903043, paramViewGroup, false);
    }
  }
  
  public static class QuizCollectionFragment2
    extends Fragment
  {
    public View onCreateView(LayoutInflater paramLayoutInflater, ViewGroup paramViewGroup, Bundle paramBundle)
    {
      return paramLayoutInflater.inflate(2130903044, paramViewGroup, false);
    }
  }
  
  public static class QuizCollectionFragment21
    extends Fragment
  {
    public View onCreateView(LayoutInflater paramLayoutInflater, ViewGroup paramViewGroup, Bundle paramBundle)
    {
      return paramLayoutInflater.inflate(2130903048, paramViewGroup, false);
    }
  }
  
  public static class QuizCollectionFragment3
    extends Fragment
  {
    public View onCreateView(LayoutInflater paramLayoutInflater, ViewGroup paramViewGroup, Bundle paramBundle)
    {
      return paramLayoutInflater.inflate(2130903045, paramViewGroup, false);
    }
  }
}


/* Location:              C:\Users\John\Desktop\java\classes-dex2jar.jar!\com\nrcssoilhealth\CollectionActivity.class
 * Java compiler version: 6 (50.0)
 * JD-Core Version:       0.7.1
 */