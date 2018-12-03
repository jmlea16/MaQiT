% Merge GeoJSON files, convert to format readable by terminus toolbox and
% convert to shapefile

clearvars termini merged

[filenames,folder_path]=uigetfile({'*.GeoJSON;*.JSON;*.shp','Shapefile/JS objects (*.GeoJSON,*.JSON,*.shp)'}...
    ,'Select file(s) to convert/merge','MultiSelect','on');

merged=[];
a=0;
b=0;
if length(string(filenames))==1
    filenames={filenames};    
end
[~,~,suffix]=fileparts(filenames{1});
if strcmp(suffix,'.geojson')||strcmp(suffix,'.json')
    for n=1:length(filenames)
        input_file=fileread(strcat(folder_path,filenames{n}));
        input=jsondecode(input_file);
        merged=[merged;input];
    end

    
    for n=1:length(merged)
        if isfield(merged(n).features(1).properties,'Satellite')
            for m=1:length(merged(n).features)
                if strcmp(merged(n).features(m).geometry.type,'LineString')
                    a=a+1;
                    margin(a).Name=merged(n).features(m).properties.Name;
                    margin(a).Date=merged(n).features(m).properties.Date;
                    margin(a).Unclear=merged(n).features(m).properties.Unclear;
                    margin(a).Description='EarthEngine';
                    margin(a).Satellite=merged(n).features(m).properties.Satellite;
                    margin(a).Asc_Desc=merged(n).features(m).properties.Asc_Desc; 
                    margin(a).ImagePath=merged(n).features(m).properties.ImagePath;
                    margin(a).Notes=merged(n).features(m).properties.Notes;  
                    margin(a).X=merged(n).features(m).geometry.coordinates(:,1);
                    margin(a).Y=merged(n).features(m).geometry.coordinates(:,2);
                    margin(a).Geometry='Line';
                elseif strcmp(merged(n).features(m).geometry.type,'Polygon')
                    b=b+1
                    margin1(b).Name=merged(n).features(m).properties.Name;
                    margin1(b).Date=merged(n).features(m).properties.Date;
                    margin1(b).Unclear=merged(n).features(m).properties.Unclear;
                    margin1(b).Description='EarthEngine';
                    margin1(b).Satellite=merged(n).features(m).properties.Satellite;
                    margin1(b).Asc_Desc=merged(n).features(m).properties.Asc_Desc; 
                    margin1(b).ImagePath=merged(n).features(m).properties.ImagePath;
                    margin1(b).Notes=merged(n).features(m).properties.Notes; 
                    margin1(b).X=merged(n).features(m).geometry.coordinates(:,1);
                    margin1(b).Y=merged(n).features(m).geometry.coordinates(:,2);
                    margin1(b).Geometry='Polygon';
                end
            end
        else
            margin2.Name='Name';
            margin2.X=merged.features.geometry.coordinates(:,1);
            margin2.Y=merged.features.geometry.coordinates(:,2);
            margin2.Geometry='Line';
        end
    end
elseif strcmp(suffix,'.shp')
    for n=1:length(filenames)
        merged{n}=shaperead(strcat(folder_path,filenames{n}));
    end
    a=0;
    b=0;
    for n=1:length(merged)
        if isfield(merged{n},'Satellite')
            for m=1:length(merged{n})
                if strcmp(merged{n}(m).Geometry,'Line')
                    a=a+1;
                    margin(a).Name=merged{n}(m).Name;
                    margin(a).Date=merged{n}(m).Date;
                    margin(a).Unclear=merged{n}(m).Unclear;
                    margin(a).Description='Merged shapefile';
                    margin(a).Satellite=merged{n}(m).Satellite;
                    margin(a).Asc_Desc=merged{n}(m).Asc_Desc; 
                    margin(a).ImagePath=merged{n}(m).ImagePath;
                    margin(a).Notes=merged{n}(m).Notes; 
                    margin(a).X=merged{n}(m).X;
                    margin(a).Y=merged{n}(m).Y;
                    margin(a).Geometry='Line';
                elseif strcmp(merged{n}(m).Geometry,'Polygon')
                    b=b+1;
                    margin1(b).Name=merged{n}(m).Name;
                    margin1(b).Date=merged{n}(m).Date;
                    margin1(b).Unclear=merged{n}(m).Unclear;
                    margin1(b).Description='Merged shapefile';
                    margin1(b).Satellite=merged{n}(m).Satellite;
                    margin1(b).Asc_Desc=merged{n}(m).Asc_Desc; 
                    margin1(b).ImagePath=merged{n}(m).ImagePath;
                    margin1(b).Notes=merged{n}(m).Notes; 
                    margin1(b).X=merged{n}(m).X;
                    margin1(b).Y=merged{n}(m).Y;
                    margin1(b).Geometry='Polygon';
                end
            end
                   
        else
            for m=1:length(merged{n})
                margin2.Name='Name';
                margin2.X=merged{n}(m).X;
                margin2.Y=merged{n}(m).Y;
                margin2.Geometry='Line';
            end
        end
    end
end

[save_filename,save_folder_path]=uiputfile({'*.shp','Shapefile (*.shp)'},'Save shapefile as:');
if exist('margin')==1
    shapewrite(margin,strcat(save_folder_path,save_filename(1:end-4),'_line.shp'));
end
if exist('margin1')==1
    shapewrite(margin1,strcat(save_folder_path,save_filename(1:end-4),'_polygon.shp'));
end
if exist('margin2')==1
    shapewrite(margin2,strcat(save_folder_path,save_filename));
end

msgbox('Files successfully converted/merged. The single shapefile generated can now be used in MaQiT.')