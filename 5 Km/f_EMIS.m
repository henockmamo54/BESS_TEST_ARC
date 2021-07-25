function f_EMIS(year,month)
	year= double(year);
	month= double(month) ;
	
	% Prepare
	r = 1/120;
	MSK = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.30s.mat');
	DATA = nan(size(MSK),'single');
	data = nan(sum(MSK(:)),1,'single');  
	MOD = nan(sum(MSK(:)),1,'single');  
	MYD = nan(sum(MSK(:)),1,'single');  
	temp = nan(sum(MSK(:)),1,'single'); 
	idx = zeros(size(MSK),'uint32');
	idx(MSK) = 1:sum(MSK(:));
	msk = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
		   
	% Process day by day
	for day = 1:31
		vec = datevec(datenum(year,month,day));
		if vec(2) == month
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;
			  
			% MOD
			MOD(:) = nan; 
			temp(:) = nan;
			try
				% load(sprintf('../Terra_L2/%d%03d/swaths.mat',year,doy));
				% index = importdata(sprintf('../Terra_L2/%d%03d/index.mat',year,doy));
				load(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_swaths.mat',year,doy));
				index = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_index.mat',year,doy));                
				index = imresize(index,size(MSK),'nearest');
				index = index(MSK); 
				flgMOD = true;
			catch
				flgMOD = false;
			end  
			if flgMOD
				for i = 1:length(hm)
					mski = index == i;
					try
						% EMIS31 = importdata(sprintf('/environment/Chongya/BESSv2/MOD_EMIS31/%d%03d/MOD_EMIS31.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
						EMIS31 = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_EMIS31/%d%03d/MOD_EMIS31.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
						EMIS31 = single(EMIS31);
						EMIS31(EMIS31<=0) = nan;
						EMIS31 = EMIS31 * 0.002 + 0.49;
						% EMIS32 = importdata(sprintf('/environment/Chongya/BESSv2/MOD_EMIS32/%d%03d/MOD_EMIS32.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
						EMIS32 = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_EMIS32/%d%03d/MOD_EMIS32.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
						EMIS32 = single(EMIS32);
						EMIS32(EMIS32<=0) = nan;
						EMIS32 = EMIS32 * 0.002 + 0.49;
						EMIS = 0.273 + 1.778*EMIS31 - 1.807*EMIS31.*EMIS32 - 1.037*EMIS32 + 1.774*EMIS32.^2;

					% lat = importdata(sprintf('/environment/Chongya/BESSv2/MOD_LAT/%d%03d/MOD_LAT.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
					lat = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_LAT/%d%03d/MOD_LAT.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
					% lon = importdata(sprintf('/environment/Chongya/BESSv2/MOD_LON/%d%03d/MOD_LON.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
					lon = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_LON/%d%03d/MOD_LON.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
					lat = imresize(lat,size(EMIS));
					lat(lat>89.9999) = 89.9999;
					lat(lat<-89.9999) = -89.9999;
					lon = imresize(lon,size(EMIS)); 
					lon(lon>179.9999) = 179.9999;
					lon(lon<-179.9999) = -179.9999;
				   
					% Grid coordinates
					lat0 = floor(lat/r)*r + r/2;
					lon0 = floor(lon/r)*r + r/2;
					% Grid positions
					row = uint32((90-r/2-lat0)/r) + 1;
					col = uint32((lon0-(-180+r/2))/r) + 1;
					% Map index
					ind = sub2ind(size(MSK),row,col);
					% Vector index
					pid = idx(ind);
		 
					msk_  = pid > 0;
					pid_ = pid(msk_);
					EMIS_ = EMIS(msk_);
		   
					temp(pid_) = EMIS_;  
					MOD(mski) = temp(mski); 
					catch
						continue;
					end                    
				end   
				DATA(MSK) = MOD;
				DATA = ndnanfilter(DATA,'hamming',[2,2]);
				MOD = DATA(MSK); 
			end
			
			% MYD
			MYD(:) = nan; 
			temp(:) = nan;
			try
				% load(sprintf('../Aqua_L2/%d%03d/swaths.mat',year,doy));
				% index = importdata(sprintf('../Aqua_L2/%d%03d/index.mat',year,doy));
				load(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Aqua_swaths.mat',year,doy));
				index = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Aqua_index.mat',year,doy));                
				index = imresize(index,size(MSK),'nearest');
				index = index(MSK); 
				flgMYD = true;
			catch
				flgMYD = false;
			end
			if flgMYD
				for i = 1:length(hm)
					mski = index == i;
					try
						% EMIS31 = importdata(sprintf('/environment/Chongya/BESSv2/MYD_EMIS31/%d%03d/MYD_EMIS31.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
						EMIS31 = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_EMIS31/%d%03d/MYD_EMIS31.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
						EMIS31 = single(EMIS31);
						EMIS31(EMIS31<=0) = nan;
						EMIS31 = EMIS31 * 0.002 + 0.49;
						% EMIS32 = importdata(sprintf('/environment/Chongya/BESSv2/MYD_EMIS32/%d%03d/MYD_EMIS32.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
						EMIS32 = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_EMIS32/%d%03d/MYD_EMIS32.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
						EMIS32 = single(EMIS32);
						EMIS32(EMIS32<=0) = nan;
						EMIS32 = EMIS32 * 0.002 + 0.49;
						EMIS = 0.273 + 1.778*EMIS31 - 1.807*EMIS31.*EMIS32 - 1.037*EMIS32 + 1.774*EMIS32.^2;
					catch
						continue;
					end
					% lat = importdata(sprintf('/environment/Chongya/BESSv2/MYD_LAT/%d%03d/MYD_LAT.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
					lat = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_LAT/%d%03d/MYD_LAT.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
					% lon = importdata(sprintf('/environment/Chongya/BESSv2/MYD_LON/%d%03d/MYD_LON.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
					lon = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_LON/%d%03d/MYD_LON.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
					lat = imresize(lat,size(EMIS));
					lat(lat>89.9999) = 89.9999;
					lat(lat<-89.9999) = -89.9999;
					lon = imresize(lon,size(EMIS)); 
					lon(lon>179.9999) = 179.9999;
					lon(lon<-179.9999) = -179.9999;
				 
					% Grid coordinates
					lat0 = floor(lat/r)*r + r/2;
					lon0 = floor(lon/r)*r + r/2;
					% Grid positions
					row = uint32((90-r/2-lat0)/r) + 1;
					col = uint32((lon0-(-180+r/2))/r) + 1;
					% Map index
					ind = sub2ind(size(MSK),row,col);
					% Vector index
					pid = idx(ind);
		 
					msk_  = pid > 0;
					pid_ = pid(msk_);
					EMIS_ = EMIS(msk_);
			
					temp(pid_) = EMIS_;  
					MYD(mski) = temp(mski);
				end  
				DATA(MSK) = MYD; 
				DATA = ndnanfilter(DATA,'hamming',[2,2]);
				MYD = DATA(MSK); 
			end
			  
			data = nanmean(cat(2,MOD,MYD),2);
			mkdir('/bess19/Yulin/BESSv2/EMIS_MCD/');
			save(sprintf('/bess19/Yulin/BESSv2/EMIS_MCD/EMIS_MCD.%d.%03d.mat',year,doy),'data');
			
			DATA(MSK) = data;
			data = f_Aggregate(DATA,6);
			data = data(msk);
			mkdir('/bess19/Yulin/BESSv2/EMIS_MCD^/');
			sprintf('/bess19/Yulin/BESSv2/EMIS_MCD^/EMIS_MCD^.%d.%03d.mat',year,doy)
			save(sprintf('/bess19/Yulin/BESSv2/EMIS_MCD^/EMIS_MCD^.%d.%03d.mat',year,doy),'data');
		end
	end
    
 