setwd("~/election_forecasts/post_mortem")
library(ggplot2)
library(data.table)
makepic<-function(file,width,height){
  fname <- paste("tex/",file,".tex",sep="")
  tikz(fname, 
       standAlone = TRUE, 
       width = width, height = height,
       packages=c(options()$tikzLatexPackages,
                  "\\usepackage{amsfonts}"),sanitize=TRUE) 
}
require(tikzDevice)
options(tikzMetricPackages = c("\\usepackage[utf8]{inputenc}",
                               "\\usepackage[T1]{fontenc}", 
                               "\\usetikzlibrary{calc}", 
                               "\\usepackage{amssymb}"))


final<-read.csv('data//final_pred.csv')
ev<-read.csv('data//ev.csv')
nat_polls<-read.csv('data//nat_polls.csv')
winner<-c()
for(i in 1:nrow(ev)){
  if(ev$electoral_vote_list[i]>=270){winner<-append(winner,'Clinton Wins')}
  else{winner<-append(winner,'Trump Wins')}
}
ev$winner<-winner


real_dem_margins<-c()
for(i in 1:nrow(final)){
  if(final$Actual.Winner[i]=='Clinton'){
    real_dem_margins<-append(real_dem_margins,final$Actual.Margin.of.Victory[i])
  }else{
    real_dem_margins<-append(real_dem_margins,-1*final$Actual.Margin.of.Victory[i])
  }
}
write.csv(nat_polls,'data//nat_polls.csv',row.names=F)
####################################################################
# My Model
####################################################################
#States incorrectly predicted
final[row.names(subset(final,Predictive.Winner!=Actual.Winner)),]

pred_dem_margins<-c()
for(i in 1:nrow(final)){
  if(final$Predictive.Winner[i]=='Clinton'){
    pred_dem_margins<-append(pred_dem_margins,final$Predictive.Margin.of.Victory[i])
  }else{
    pred_dem_margins<-append(pred_dem_margins,-1*final$Predictive.Margin.of.Victory[i])
  }
}

#Median Error
median(abs(pred_dem_margins-real_dem_margins))

#RMSE
sqrt((1/nrow(final))*sum((pred_dem_margins-real_dem_margins)^2))
####################################################################
# My Model
####################################################################


####################################################################
# NYT Upshot
####################################################################
pred_nyt_dem_margins<-c()
for(i in 1:nrow(final)){
  if(final$NYT.Winner[i]=='Clinton'){
    pred_nyt_dem_margins<-append(pred_nyt_dem_margins,final$NYT.Margin.of.Victory[i])
  }else{
    pred_nyt_dem_margins<-append(pred_nyt_dem_margins,-1*final$NYT.Margin.of.Victory[i])
  }
}

#Median Error
median(abs(pred_nyt_dem_margins-real_dem_margins))

#NYT RMSE
sqrt((1/nrow(final))*sum((pred_nyt_dem_margins-real_dem_margins)^2))
####################################################################
# NYT Upshot
####################################################################


####################################################################
# FiveThirtyEight
####################################################################
pred_fte_dem_margins<-c()
for(i in 1:nrow(final)){
  if(final$FTE.Winner[i]=='Clinton'){
    pred_fte_dem_margins<-append(pred_fte_dem_margins,final$FTE.Margin.of.Victory[i])
  }else{
    pred_fte_dem_margins<-append(pred_fte_dem_margins,-1*final$FTE.Margin.of.Victory[i])
  }
}

#Median Error
median(abs(pred_fte_dem_margins-real_dem_margins))

#538 RMSE
sqrt((1/nrow(final))*sum((pred_fte_dem_margins-real_dem_margins)^2))
####################################################################
# FiveThirtyEight
####################################################################


####################################################################
# Huffington Post
####################################################################

pred_hp_dem_margins<-c()
for(i in 1:nrow(final)){
  if(final$HP.Winner[i]=='Clinton'){
    pred_hp_dem_margins<-append(pred_hp_dem_margins,final$HP.Margin.of.Victory[i])
  }else{
    pred_hp_dem_margins<-append(pred_hp_dem_margins,-1*final$HP.Margin.of.Victory[i])
  }
}

#Median Error
median(abs(pred_hp_dem_margins-real_dem_margins))

#Huffington Post RMSE
sqrt((1/nrow(final))*sum((pred_hp_dem_margins-real_dem_margins)^2))
####################################################################
# Huffington Post
####################################################################


####################################################################
# PEC
####################################################################
pred_pec_dem_margins<-c()
for(i in 1:nrow(final)){
  if(final$PEC.Winner[i]=='Clinton'){
    pred_pec_dem_margins<-append(pred_pec_dem_margins,final$PEC.Margin.of.Victory[i])
  }else{
    pred_pec_dem_margins<-append(pred_pec_dem_margins,-1*final$PEC.Margin.of.Victory[i])
  }
}

#Median Error
median(abs(pred_pec_dem_margins-real_dem_margins))

#PEC RMSE
sqrt((1/nrow(final))*sum((pred_pec_dem_margins-real_dem_margins)^2))
####################################################################
# PEC
####################################################################


####################################################################
# Daily Kos
####################################################################
pred_dk_dem_margins<-c()
for(i in 1:nrow(final)){
  if(final$DK.Winner[i]=='Clinton'){
    pred_dk_dem_margins<-append(pred_dk_dem_margins,final$DK.Margin.of.Victory[i])
  }else{
    pred_dk_dem_margins<-append(pred_dk_dem_margins,-1*final$DK.Margin.of.Victory[i])
  }
}

median(abs(pred_dk_dem_margins-real_dem_margins))

#Daily Kos RMSE
sqrt((1/nrow(final))*sum((pred_dk_dem_margins-real_dem_margins)^2))
####################################################################
# Daily Kos
####################################################################


####################################################################
# Daily Kos
####################################################################




####################################################################
# Daily Kos
####################################################################


dt<-data.table(ev)

gg <- dt[,list(x=density(ev$electoral_vote_list)$x, y=density(ev$electoral_vote_list)$y)]

makepic('dem_prob',6,3)
windowsFonts(Times=windowsFont("TT Times New Roman"))
ggplot(dt) +
  theme(text=element_text(family="Times", face="bold", size=20))+
  geom_ribbon(data=subset(gg,gg$x>=270),aes(x=x,ymax=y),ymin=0,fill="#00AEF3", alpha=0.5)+
  geom_ribbon(data=subset(gg,gg$x<271),aes(x=x,ymax=y),ymin=0,fill="#D81A21", alpha=0.5)+
  geom_ribbon(data=subset(gg,gg$x>242 & gg$x<375),aes(x=x,ymax=.0013+max(y)),ymin=0,fill="grey", alpha=0.4)+
  theme(panel.background = element_blank())+
  # Format the grid
  theme(panel.grid.major=element_line(colour="#D0D0D0",size=.05)) +
  theme(panel.grid.minor=element_blank()) +
  #scale_x_continuous(minor_breaks=0,breaks=seq(0,100,10),limits=c(0,100)) +
  #scale_y_continuous(minor_breaks=0,breaks=seq(0,26,4),limits=c(0,25)) +
  scale_y_continuous(breaks = NULL)+
  
  theme(axis.ticks=element_blank()) +
  # Dispose of the legend
  theme(legend.position="bottom") +
  # Set title and axis labels, and format these and tick marks
  ggtitle("Clinton's Chances of Winning") +
  theme(plot.title=element_text(face="bold",hjust=-.08,vjust=2,colour="#3C3C3C",size=20)) +
  theme(axis.text.x=element_text(size=11,colour="#535353",face="bold")) +
  theme(axis.text.y=element_blank()) +
  theme(axis.title.y=element_text(size=11,colour="#535353",face="bold",vjust=1.5)) +
  theme(axis.title.x=element_text(size=11,colour="#535353",face="bold",vjust=-.5))+
  xlab('Electoral Votes')+
  ylab('')+
  geom_hline(yintercept=0,size=1.2,colour="#535353")+
  #geom_vline(xintercept=270,size=1,colour="#535353")+
  #geom_vline(xintercept=375,size=1,colour="#535353")+
  xlim(150,450)+
  geom_text(aes(x=317, label='95%',
                y=.0006+max(density(ev$electoral_vote_list)$y)),
                colour="grey38",size=5,family='Times')+
  geom_text(aes(x=320, label="Clinton Wins",
                y=max(density(ev$electoral_vote_list)$y)/3),
                colour="#0089c0",size=5,family='Times')+
  geom_text(aes(x=250, label="Trump Wins",
                y=max(density(ev$electoral_vote_list)$y)/25),
                colour="#a41e1e",size=3,family='Times')+
  theme(text=element_text(size=16, family="Times"))
dev.off()
   



model<-c(
  'Mine',
  'NYT Upshot',
  'FiveThirtyEight',
  'HuffPost',
  'PEC',
  'Daily Kos'
)

RMSE<-round(c(
  sqrt((1/nrow(final))*sum((pred_dem_margins-real_dem_margins)^2)),
  sqrt((1/nrow(final))*sum((pred_nyt_dem_margins-real_dem_margins)^2)),
  sqrt((1/nrow(final))*sum((pred_fte_dem_margins-real_dem_margins)^2)),
  sqrt((1/nrow(final))*sum((pred_hp_dem_margins-real_dem_margins)^2)),
  sqrt((1/nrow(final))*sum((pred_pec_dem_margins-real_dem_margins)^2)),
  sqrt((1/nrow(final))*sum((pred_dk_dem_margins-real_dem_margins)^2))
),2)

median_error<-c(
  median(abs(pred_dem_margins-real_dem_margins)),
  median(abs(pred_nyt_dem_margins-real_dem_margins)),
  median(abs(pred_fte_dem_margins-real_dem_margins)),
  median(abs(pred_hp_dem_margins-real_dem_margins)),
  median(abs(pred_pec_dem_margins-real_dem_margins)),
  median(abs(pred_dk_dem_margins-real_dem_margins))
)

model_rmse<-data.frame(model,RMSE,median_error)


makepic('median_err',7,3)
ggplot(data=model_rmse, aes(x=reorder(model,median_error), y=median_error)) +
  # Set the entire chart region to a light gray color
  #theme(panel.background=element_rect(fill="#F0F0F0")) +
  #theme(plot.background=element_rect(fill="#F0F0F0")) +
  # theme(panel.border=element_rect(colour="#F0F0F0")) +
  theme(panel.background = element_blank())+
  # Format the grid
  theme(panel.grid.major=element_line(colour="#D0D0D0",size=.75)) +
  theme(panel.grid.minor=element_blank()) +
  #scale_x_continuous(minor_breaks=0,breaks=seq(0,100,10),limits=c(0,100)) +
  #scale_y_continuous(minor_breaks=0,breaks=seq(0,26,4),limits=c(0,25)) +
  theme(panel.grid.major.x = element_blank())+
  theme(axis.ticks=element_blank()) +
  # Dispose of the legend
  theme(legend.position="none") +
  # Set title and axis labels, and format these and tick marks
  ggtitle("Forecasting Errors") +
  theme(plot.title=element_text(face="bold",hjust=-.08,vjust=2,colour="#3C3C3C",size=20)) +
  theme(axis.text.x=element_text(size=8,colour="#535353",face="bold")) +
  theme(axis.text.y=element_text(size=11,colour="#535353",face="bold")) +
  theme(axis.title.y=element_text(size=11,colour="#535353",face="bold",vjust=1.5)) +
  theme(axis.title.x=element_text(size=11,colour="#535353",face="bold",vjust=-.5))+
  geom_bar(stat="identity",fill="#DD8888", width=.8) +
  coord_cartesian(ylim=c(4,7))+
  xlab('')+
  ylab('Median Error')+
  geom_hline(yintercept=3.85,size=1.2,colour="#535353")
dev.off()

makepic('clinton_lead',7,3)
ggplot(subset(nat_polls,election_year==2016 & days_till_election<=90),aes(x=as.Date(Date),y=running_avg))+
  geom_line(colour='#00AEF3',size=3)+
  theme(panel.background = element_blank())+
  # Format the grid
  theme(panel.grid.major=element_line(colour="#D0D0D0",size=.75)) +
  theme(panel.grid.minor=element_blank()) +
  theme(panel.grid.major.x = element_blank())+
  theme(axis.ticks=element_blank()) +
  ggtitle("Clinton's Unstable Lead") +
  theme(plot.title=element_text(face="bold",hjust=-.08,vjust=2,colour="#3C3C3C",size=20)) +
  theme(axis.text.x=element_text(size=8,colour="#535353",face="bold")) +
  theme(axis.text.y=element_text(size=11,colour="#535353",face="bold")) +
  theme(axis.title.y=element_text(size=11,colour="#535353",face="bold",vjust=1.5)) +
  theme(axis.title.x=element_text(size=11,colour="#535353",face="bold",vjust=-.5))+
  coord_cartesian(ylim=c(0,8))+
  ylab("Lead in Polls (% Points)")+
  xlab("")
dev.off()
  
  
  
  
  
  
  

