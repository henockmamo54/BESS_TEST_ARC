function f_LAIFPAR(year,month,opt)

	year= double(year);
	month= double(month) ;

	% Prepare
	msk30s = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.30s.mat');
	msk005d = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
	path = '/bess19/Yulin/Data/MCD15A3H';
	if strcmp(opt,'LAI')
		field = 'Lai_500m';
		sf = 0.1;
	elseif strcmp(opt,'FPAR')
		field = 'Fpar_500m';
		sf = 0.01;
	end
	ds = sprintf('%s_MCD',opt);
	temp = nan(size(msk30s),'single');
	id = importdata('/bess19/Yulin/BESSv2/Ancillary/id_500m_30s.mat');
	sidelength = 2400;
	height = 43200;
	width = 86400;
	huge = zeros(height,width,'uint8');
	   
	% Process day by day
	for day = 1:31
		vec = datevec(datenum(year,month,day));
		if vec(2) == month
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;
		
			% List all tile files
			directory = dir(sprintf('%s/%d/%03d/*A%d%03d*.hdf',path,year,doy,year,doy));
			names = {directory.name};
			if length(names) == 0
				continue;
			end
			% Initialize global matrix and BESS grid
			huge(:) = 255;
			temp(:) = nan;
			% Fill the matrix file by file
			for k = 1:length(names)
				% Read dataset tile from HDF file
				url = sprintf('%s/%d/%03d/%s',path,year,doy,names{k});
				% Identify tile name from file name
				ind = regexp(url,'h\d\dv\d\d');
				tile = url(ind:ind+5);
				% Convert tile number to matrix position
				h = str2num(tile(2:3));
				v = str2num(tile(5:6));
				j = (h-0)*sidelength + 1;
				i = (v-0)*sidelength + 1;
				% Read data and qc
				raw = hdfread(url,field);
				qc = hdfread(url,'FparLai_QC');
				% Use only main algorithm data
				raw = single(raw);  
				raw(qc>=64) = 255;
				% Fill the global huge matrix
				huge(i:i+sidelength-1,j:j+sidelength-1) = raw;
			end 
			% Convert from 500m to 30s
			msk = huge < 255;
			temp(id(msk)) = huge(msk); 
			clear msk 
			% Convert DN to value
			temp(temp==255) = nan;
			temp(temp<=254&temp>=252) = 0;
			temp(temp<=251&temp>=249) = nan;
			temp = temp * sf;
			% Write in BESS format
			data = temp(msk30s);
			mkdir(sprintf('/bess19/Yulin/BESSv2/%s_MCD/',opt));
			save(sprintf('/bess19/Yulin/BESSv2/%s_MCD/%s_MCD.%d.%03d.mat',opt,opt,year,doy),'data');
			% Aggregate to 0.05 degree
			temp_ = f_Aggregate(temp,6);
			% Write in BESS format
			data = temp_(msk005d);
			mkdir(sprintf('/bess19/Yulin/BESSv2/%s_MCD^/',opt));
			save(sprintf('/bess19/Yulin/BESSv2/%s_MCD^/%s_MCD^.%d.%03d.mat',opt,opt,year,doy),'data'); 
		end
	end
