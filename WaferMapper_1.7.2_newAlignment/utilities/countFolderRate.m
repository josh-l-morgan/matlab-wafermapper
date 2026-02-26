%% sections per day

TPN = GetMyDir

dTPN = dir(TPN); dTPN = dTPN(3:end);

datenums=[dTPN.datenum];
isdirs = [dTPN.isdir];
names = [dTPN.name];


useDates = datenums(isdirs>0);

useDates = useDates - min(useDates);
binDates = hist(useDates,[0:1:max(useDates)]);
plot(binDates)

bin10Dates = hist(useDates,[0:10:max(useDates)]);
in100 = sum(binDates(end-119:end-20))
median(bin10Dates)

%570 sections in 10 days
