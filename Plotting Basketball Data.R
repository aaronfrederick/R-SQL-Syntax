library('tidyverse')
library('sqldf')
require(sqldf)
setwd('/Users/aaronfrederick/Desktop/Data Science:Programming/R Practice')

df <- read_csv('nba_salaries_1990_to_2018.csv')
df

df$player

#All Salaries
ggplot(data=df, aes(x=season_start, y=salary, colour=team)) +
  geom_point() +
  theme(legend.position="none")

#Moving Average
avg_yearly_sal <- sqldf("SELECT season_start as Year, AVG(salary) as Salary
                        FROM df
                        GROUP BY Year")
ggplot(data=avg_yearly_sal, aes(x=Year,y=Salary)) +
  geom_line(color='blue')

#Example to show R syntax
mean_salary2 <- aggregate(df$salary, by=list(df$season_start), FUN=mean)
ggplot(data=mean_salary2, aes(x=Group.1,y=x, colour=Group.2)) +
  geom_line(color='blue')

#All Spurs Salaries
spurs <- sqldf("SELECT season_start as Year, salary as Salary
               FROM df
               WHERE team = 'SAS'")
ggplot(data=spurs, aes(x=Year, y=Salary)) +
  geom_point()

#Using R syntax
spurs2 <- subset(df, team=='SAS')
ggplot(data=spurs2, aes(x=season_start, y=salary, color=player)) +
  geom_point() +
  theme(legend.position="none")

#All Tony Parker's Salaries
tonyp <- sqldf("SELECT season_start as Year, salary as Salary
               FROM df
               WHERE player = 'Tony Parker'")
ggplot(data=tonyp, aes(x=Year, y=Salary)) +
  geom_point(color = 'purple')

player_pay <- subset(df, player=="Tony Parker")
ggplot(data=player_pay, aes(x=season_start,y=salary)) +
  geom_point(color='orange')


team_pay <- subset(df, team=='LAL')
team_pay
ggplot(data=team_pay, aes(x=season_start,y=salary, colour=player)) +
  geom_point() +
  theme(legend.position="none")


top_sals_per_player <- sqldf("SELECT player, MAX(salary) AS pay, season_start 
                             FROM df
                              WHERE team = 'ATL'
                             GROUP BY player")
top_sals_per_player
ggplot(data=top_sals_per_player, aes(x=season_start, y=pay)) +
  geom_point()


#Taking top mean salaries
top_mean_salary <- sqldf("SELECT team, AVG(salary) as avg
                           FROM df 
                          GROUP BY team
                          ORDER BY avg DESC
                           LIMIT 10")

top_mean_salary


ggplot(data=top_mean_salary) +
  geom_col(aes(x=team, y=avg, fill=team)) +
  theme(legend.position="none")

#Using R syntax
tms <- aggregate(df$salary, by=list(df$team), FUN=mean)
colnames(tms) <- c('Team', 'Salary')
#from inside out, we are sorting tms by second column descending
#then taking the top 10 rows of the resulting dataframe
tms.2 <- head(tms[order(-tms[,2]),], 10)

ggplot(data=tms.2) +
  geom_col(aes(x=Team, y=Salary, fill=Team)) +
  theme(legend.position="none")



