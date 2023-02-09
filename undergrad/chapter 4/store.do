reg wage grade
eststo model1
regress wage grade age hours
eststo model2
regress wage grade age hours i.married
eststo model3
esttab, r2 ar2 se scalar(rmse)

