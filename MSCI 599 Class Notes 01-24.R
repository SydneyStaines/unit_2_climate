# Sydney Staines
# 2023-01-24
# Ice mass loss over poles

read.table(file = "data/antarctica_mass_200204_202209.txt", skip = 31, sep = "", header = FALSE, col.names = c("decimal_date", "mass_Gt", "sigma_Gt"))

ant_ice_loss = read.table(file = "data/antarctica_mass_200204_202209.txt", skip = 31, sep = "", header = FALSE, col.names = c("decimal_date", "mass_Gt", "sigma_Gt"))

typeof(ant_ice_loss)
class(ant_ice_loss)
dim(ant_ice_loss)

grn_ice_loss = read.table(file = "data/greenland_mass_200204_202209.txt", skip = 31, sep = "", header = FALSE, col.names = c("decimal_date", "mass_Gt", "sigma_Gt"))

head(grn_ice_loss)
tail(grn_ice_loss)
summary(grn_ice_loss)
summary(ant_ice_loss)

# plot it!
# type l makes it a line graph instead of data points

range(grn_ice_loss$mass_Gt)
plot(x=ant_ice_loss$decimal_date, y=ant_ice_loss$mass_Gt, type="l", xlab="Year", ylab="Antarctic Ice Loss (Gt)", ylim=range(grn_ice_loss$mass_Gt))
lines(mass_Gt~decimal_date, data=grn_ice_loss, col="red")
# at this point the Greenland data was falling off the graph because the y axis range was set by the Antarctic data, so we edited the y limit with ylim. You can use the actual range values themselves or put in the range so it will look at it for you

# now we want to add a data break around 2017-2018 because they weren't collecting data then since it was between GRACE missions - insert an N/A

data_break = data.frame(decimal_date=2018.0, mass_Gt=NA, sigma_Gt=NA)

# Insert data break into ice loss dataframes
ant_ice_loss_with_NA = rbind(ant_ice_loss, data_break)
grn_ice_loss_with_NA = rbind(grn_ice_loss, data_break)

dim(ant_ice_loss)
dim(ant_ice_loss_with_NA)
tail(ant_ice_loss_with_NA)

# our data break showed up as a value at the end of the table out of order. We need to put the new 2018 point in order with the rest of the data

order(ant_ice_loss_with_NA$decimal_date)
order(grn_ice_loss_with_NA$decimal_date)
# number 214 was listed between numbers 163 and 164
ant_ice_loss_with_NA = ant_ice_loss_with_NA[order(ant_ice_loss_with_NA$decimal_date), ]
tail(ant_ice_loss_with_NA)
grn_ice_loss_with_NA = grn_ice_loss_with_NA[order(grn_ice_loss_with_NA$decimal_date), ]

plot(x=ant_ice_loss_with_NA$decimal_date, y=ant_ice_loss_with_NA$mass_Gt, type="l", xlab="Year", ylab="Antarctic Ice Loss (Gt)", ylim=range(grn_ice_loss$mass_Gt)) +
lines(mass_Gt~decimal_date, data=grn_ice_loss_with_NA, col="red")

# you can add a plus sign to connect the plot and lines functions

# Error bars!
head(ant_ice_loss_with_NA)

pdf('figures/ice_mass_trends.pdf', width=7, height=5)

plot(x=ant_ice_loss_with_NA$decimal_date, y=ant_ice_loss_with_NA$mass_Gt, type="l", xlab="Year", ylab="Antarctic Ice Loss (Gt)", ylim=range(grn_ice_loss$mass_Gt))
lines((mass_Gt + 2*sigma_Gt) ~ decimal_date, data = ant_ice_loss_with_NA, lty="dashed", col="red")
lines((mass_Gt - 2*sigma_Gt) ~ decimal_date, data = ant_ice_loss_with_NA, lty="dashed", col="red")

dev.off()

# Bar plot of total ice loss

tot_ice_loss_ant= min(ant_ice_loss_with_NA$mass_Gt, na.rm=TRUE) - max(ant_ice_loss_with_NA$mass_Gt, na.rm=TRUE)

tot_ice_loss_grn= min(grn_ice_loss_with_NA$mass_Gt, na.rm=TRUE) - max(grn_ice_loss_with_NA$mass_Gt, na.rm=TRUE)

barplot(height=-1*c(tot_ice_loss_ant, tot_ice_loss_grn), 
        names.arg=c("Antarctica", "Greenland"))











