for demo =1
    clear ecg samplingrate corrected filtered1 peaks1 filtered2 peaks fresult
    switch (demo)
        case 1
            plotname = 'Sample 1 ';
            load ecgdemodata1;
    end
 
    fresult=fft(ecg);
    fresult(1:round(length(fresult)*5/samplingrate))=0;
    fresult(end-round(length(fresult)*5/samplingrate): end )=0;
    corrected=real(ifft(fresult));
    Winsize=floor(samplingrate*571/1000);
    hline=refline([0 0]);
    if rem(Winsize,2)==0
            Winsize=Winsize+1;
    end
    filtered1=ecgdemowinmax(corrected,Winsize);
    peaks1=filtered1/(max(filtered1)/7);
    for data=1:1:length(peaks1)
        if peaks1(data)<4
            peaks1(data)=0;
        else
            peaks1(data)=1;
        end
    end
    positions=find(peaks1);
    distance=positions(2)-positions(1);
    for data=1:1:length(positions)-1
        if positions(data+1)-positions(data)<distance
            distance=positions(data+1)-positions(data);
        end
    end
    QRdistance=floor(0.048*samplingrate);
    if rem(QRdistance,2)==0
        QRdistance=QRdistance+1;
    end
    WinSize=2*distance-QRdistance;
    
     filtered2=ecgdemowinmax(corrected, WinSize);
    peaks2=filtered2;
    for data=1:1:length(peaks2)
        if peaks2(data)<4
            peaks2(data)=0;
        else
            peaks2(data)=1;
        end
    end
    correctedCropped=corrected(2447:2814);
    Finalone=real(ifft(filtered2));
    positions2=find(peaks2);
    distanceBetweenFirstAndLastPeaks = positions2(length(positions2))-positions2(1);
 
    averageDistanceBetweenPeaks = distanceBetweenFirstAndLastPeaks/length(positions2);
    
    averageHeartRate = 60 * samplingrate/averageDistanceBetweenPeaks;
    
    disp('Average Heart Rate = ');
    disp(averageHeartRate);
    
    figure(demo); set(demo, 'Name', strcat(plotname, ' - Processing Stages'));
    subplot(3, 2, 1); plot((ecg-min(ecg))/(max(ecg)-min(ecg)));
    title('\bf1. Original ECG'); ylim([-0.2 1.2]);
    subplot(3, 2, 2); plot((corrected-min(corrected))/(max(corrected)-min(corrected)));
    title('\bf2. FFT Filtered ECG'); ylim([-0.2 1.2]);
    subplot(3, 2, 3); stem((filtered1-min(filtered1))/(max(filtered1)-min(filtered1)));
    title('\bf3. Filtered ECG - 1^{st} Pass'); ylim([0 1.4]);
     subplot(3, 2, 4); stem(peaks1);
    title('\bf4. Detected Peaks'); ylim([0 1.4]);
    subplot(3, 2, 5); stem((filtered2-min(filtered2))/(max(filtered2)-min(filtered2)));
    title('\bf5. Filtered ECG - 2^d Pass'); ylim([0 1.4]);
    %   Detected peaks - final result
    subplot(3, 2, 6); stem(peaks2);
    title('\bf6. Detected Peaks - Finally'); ylim([0 1.4]);
    %   Create figure - result
    figure(demo+1); set(demo+1, 'Name', strcat(plotname, ' - Result'));
    %   Plotting ECG in green
    
    plot((ecg-min(ecg))/(max(ecg)-min(ecg)), '-g'); title('\bf Comparative ECG R-Peak Detection Plot');
    
    %   Show peaks in the same picture
    %%%%%%%%%%%%plot(Finalone);
    hold on
    %   Stemming peaks in dashed black
    stem(peaks2'.*((ecg-min(ecg))/(max(ecg)-min(ecg)))', ':k');
    %   Hold off the figure
    
   
    figure(demo+2); set(demo+2, 'Name', strcat(plotname, ' - Result'));
    
    plot(correctedCropped);
    hold on
    xL = get(gca, 'XLim');
    plot(xL, [0 0], '-')
 
    
   
end

