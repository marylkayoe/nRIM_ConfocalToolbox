function [laserWL, laserPower, zoomInfo] = getZeissMetadata(metadata)
%% zoom factor

zoomInfoKey = 'Global Information|Image|Channel|LaserScanInfo|ZoomX #1';
if metadata.containsKey(zoomInfoKey)
    zoomInfoStr = metadata.get(zoomInfoKey);

    zoomInfo = str2num(zoomInfoStr);


%    disp(['Zoom Info: ', zoomInfo]);
else
    disp('Zoom information not found in metadata.');
end


% %% Objective
% 
% objInfoKey = 'Global Experiment|AcquisitionBlock|AcquisitionModeSetup|Objective #1';
% if metadata.containsKey(objInfoKey)
%     objInfo = metadata.get(objInfoKey);
%     disp(['Obj Info: ', objInfo]);
% else
%     disp('Obj information not found in metadata.');
% end


%% Laser power

laserPowerKey = 'Global Experiment|AcquisitionBlock|Laser|LaserPower #1';
if metadata.containsKey(laserPowerKey)
    laserPowerStr = metadata.get(laserPowerKey);
    laserPower = str2num(laserPowerStr);
   
   % disp(['Laser power: ', laserPowerInfo]);
else
    disp('Obj information not found in metadata.');
end



%% Laser wavelength

laserWLkey = 'Global Experiment|AcquisitionBlock|MultiTrackSetup|TrackSetup|Attenuator|Wavelength #1';
if metadata.containsKey(laserWLkey)
    laserWLStr = metadata.get(laserWLkey);
    laserWLm = str2double(laserWLStr);
    laserWL = round(laserWLm * 1e9); % convert to nm
   % disp(['Obj Info: ', laserWLinfo]);
else
    disp('LaserWL information not found in metadata.');
end

