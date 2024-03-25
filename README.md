# Healthcare_cost_Analysis_Data_Analytics

Master's project with a team of 4 - the goal is to analyze the healthcare cost of Healthcare Management Organization (HMO) to minimize their insurance cost for their customers:

**Primary Goals:**

* The primary goal of this project is to provide actionable insight based on the data available to predict which customers will be expensive.
* To provide recommendations that will help to lower the healthcare costs of the customers to HMO.
* Used various algorithms to analyze the key factors which lead to expensive healthcare costs.
* Deployed different predictive modelling techniques to provide actionable insights using data analysis.

**Various Phases in Analysis:**

* Loading the data with appropriate libraries and understanding the data
* Data Cleaning and explore data by using statistical methods and visualization
* To generate different prediction models and compare the model results to find the best model
* Create Shiny App for the user with the best predictive model
* Conclusion - Actionable Insights

**Dataset Description**

Dataset consists of various variables including binary and numerical values. Following are the coulmns present in the dataset:

* Binary values: Location type, Smoker, Physically active.
* Numeric Values: Age, BMI, No of Children, Cost.

**Understanding the Data**

1. The sample's age distribution ranged from 18 to 66, with a mean age of about 39. BMI levels were in the range of 16 to 53, with a mean of 31.
2. With a mean of $4,043, the insurance cost has a wide range, ranging from only $2 to $55,715. This indicates that the cost variable has several exceptionally high values that tilt it to the right.
3. We can observe 67% of the people are married and 75% of the people exercise actively which gives us the insight that all the married people are healthy.
4. 48.3% are females, just below 75% live in urban areas and nearly 20% of the customers are smokers and only 25% of the customers are physically active.

**Prediction Models**

* For each model type, we have adjusted the data so that the model will be able to read the data.
* We first used linear modeling to help us understand the significance of each variable.
* After understanding the importance of each variable, we ran the rules association model which is an unsupervised machine learning model. This provided us with the set of variables that in combination were linked to high cost.
* We ran 2 models based on the relevant variables: rpart and SVM
* SVM is a supervised machine learning model with an accuracy rate of 86.81% and rpart is an unsupervised machine learning model with an accuracy of 50%. 
* Based on the results we selected the model which is having highest accuracy and sensitivity.

**Vizualizations and Analysis:**

**1. Jittter plot of Cost v/s Smoker**

<img width="809" alt="EX-1" src="https://github.com/tankasaliharshita/Healthcare_Cost_Analysis_Data_Analytics/assets/158988940/def44d2c-4dcd-4434-94ed-1ae8a78f7d90">

**2. Box plot of Cost vs Exercise**

<img width="814" alt="EX-2" src="https://github.com/tankasaliharshita/Healthcare_Cost_Analysis_Data_Analytics/assets/158988940/98994b57-c9a3-4972-bb1f-00a10419b39e">

**3. Bar Plot of Education Level vs Cost**

<img width="812" alt="EX-3" src="https://github.com/tankasaliharshita/Healthcare_Cost_Analysis_Data_Analytics/assets/158988940/8e4f511d-6ba1-41d9-8276-0f335be40447">

**4. Bar plot of Smokers vs Age**

![image](https://github.com/tankasaliharshita/Healthcare_Cost_Analysis_Data_Analytics/assets/158988940/eb3d5707-70ff-44c5-a518-4292b1a7f18d)

**5. Map showing which state is paying more Healthcare Cost**

<img width="587" alt="EX-4" src="https://github.com/tankasaliharshita/Healthcare_Cost_Analysis_Data_Analytics/assets/158988940/d5896152-ae84-4e12-b892-7f94e9b7006c">

**6. Overview of Shiny Website for User**

<img width="960" alt="EX-5" src="https://github.com/tankasaliharshita/Healthcare_Cost_Analysis_Data_Analytics/assets/158988940/81ee4844-d03b-4a80-96ba-43b4d7cbcd58">




