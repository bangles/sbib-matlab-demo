function fid = pbrt_render( TYPE, varargin )

%%% Instantiate a parser
p = inputParser;

% discriminate on TYPE
if strcmp( TYPE, 'init' )
    p.addOptional('filename','input.pbrt', @ischar );
    p.addParamValue('lookat',[0 0 4 0 0 0 0 1 0], @isnumeric );
    p.addParamValue('resolution',[640 640], @isnumeric );
    p.parse( varargin{:} );
    lookat = p.Results.lookat;
    filename  = p.Results.filename;
    resolution = p.Results.resolution;
    
    % open the file
    fid = fopen(sprintf('%s.pbrt',filename), 'w');

    % setup the viewpoint
    fprintf( fid,'LookAt %f %f %f %f %f %f %f %f %f\n', lookat); % from, to, up
    fprintf( fid,'Film "image" "string filename" ["%s"] "integer xresolution" [%f] "integer yresolution" [%f]\n',...
             sprintf('%s.exr',filename), resolution(1), resolution(2) );
    fprintf( fid, 'Camera "orthographic" "float yon" [8] "float screenwindow" [-1.1 1.1 -1.1 1.1]\n'); 

    %%% BEGIN THE WORLD
    fprintf( fid, 'WorldBegin\n' );

    % setup the lighting
    fprintf( fid, 'AttributeBegin\n' );
        fprintf( fid, '\tCoordSysTransform "camera"\n' );
        fprintf( fid, '\tLightSource "point" "color I" [60 60 60] "point from" [  0   0  0 ]\n' );
%         fprintf( fid, '\tLightSource "point" "color I" [20 20 20] "point from" [  50  2  -1 ]\n' );
%         fprintf( fid, '\tLightSource "point" "color I" [20 20 20] "point from" [ -50  2  -1 ]\n' );
    fprintf( fid, 'AttributeEnd\n\n');
    
elseif strcmp( TYPE, 'mesh' )
    p.addRequired('fid', @isnumeric);
    p.addRequired('mesh', @isstruct);
    p.addParamValue('modelview', makehgtform, @isnumeric);
    p.parse( varargin{:} );
    fid = p.Results.fid;
    M = p.Results.mesh;
    modelview = p.Results.modelview;
    
    fprintf( fid, 'AttributeBegin\n' );
        % setup transform
        fprintf( fid, '\tTransform [%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f]\n', modelview );
        % setup "base" colors
        if isfield(M,'FaceVertexCData')
            fprintf( fid, '\tMaterial "plastic" "color Kd" [0 0 0] "color Ks" [.1 .1 .1] "float roughness" [.005] \n');
        else
            fprintf( fid, '\tMaterial "plastic" "color Kd" [1 0 0] "color Ks" [.1 .1 .1] "float roughness" [.005] \n');
        end
        % write the triangles
        fprintf( fid, '\tShape "trianglemesh"\n');
 
        % coordinates
        fprintf( fid, '\t\t"point P" [');
        for vIdx=1:size( M.vertices, 1 )
           fprintf(fid, '%f %f %f ', M.vertices(vIdx,:));
        end
        fprintf( fid, ']\n');

        % connectivity
        fprintf( fid, '\t\t"integer indices" [');
        for fIdx=1:size( M.faces, 1 )
           fprintf(fid, '%d %d %d ', M.faces(fIdx,:)-1 );
        end
        fprintf( fid, ']\n');

        % optional - normals (smooth shading)
        if isfield(M,'VN')
            fprintf( fid, '\t\t"normal N" [');
            for vIdx=1:size( M.vertices, 1 )
               fprintf(fid, '%d %d %d ', M.VN(vIdx,:) );
            end
            fprintf( fid, ']\n');
        end

        % optional - colors
        if isfield(M,'FaceVertexCData')
            fprintf( fid, '\t\t"color kd" [');
            for vIdx=1:size( M.FaceVertexCData, 1 )
               fprintf(fid, '%d %d %d ', M.FaceVertexCData(vIdx,:) );
            end
            fprintf( fid, ']\n');
        end
    fprintf( fid, 'AttributeEnd\n\n' );
    
elseif strcmp( TYPE, 'pcloud' )
    p.addRequired('fid', @isnumeric);
    p.addRequired('pcloud', @isstruct);
    p.addParamValue('samplesize', .005, @isnumeric );
    p.addParamValue('modelview', makehgtform, @isnumeric);
    p.parse( varargin{:} );
    fid = p.Results.fid;
    samplesize = p.Results.samplesize;
    modelview = p.Results.modelview;
    P = p.Results.pcloud;
    
    fprintf( fid, 'AttributeBegin\n' );
        fprintf( fid, '\tMaterial "plastic" "color Kd" [1 0 0] "color Ks" [.1 .1 .1] "float roughness" [.005] \n\n');
        for pIdx1=1:size(P.points,1)
            fprintf( fid, '\tCoordSysTransform "world"\n' );
            fprintf( fid, '\tTransform [%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f]\n', modelview );
            fprintf( fid, '\tTranslate %f %f %f\n', P.points(pIdx1,:) );
            fprintf( fid, '\tShape "sphere" "float radius" [%f]\n\n', samplesize);
        end
    fprintf( fid, 'AttributeEnd\n\n' );

elseif strcmp( TYPE, 'polyline' )
    p.addRequired('fid', @isnumeric);
    p.addRequired('polyline', @isnumeric);
    p.addParamValue('linewidth',  .005, @isnumeric );
    p.addParamValue('samplesize', .005, @isnumeric );
    p.addParamValue('modelview', makehgtform, @isnumeric);
    p.parse( varargin{:} );
    fid = p.Results.fid;
    linewidth = p.Results.linewidth;
    modelview = p.Results.modelview;
    samplesize = p.Results.samplesize;
    P = p.Results.polyline;
    
    fprintf( fid, 'AttributeBegin\n' );
        fprintf( fid, '\tMaterial "plastic" "color Kd" [1 0 0] "color Ks" [.1 .1 .1] "float roughness" [.005] \n');
        for i=1:size(P,1)-1;
            P1 = P(i,:);
            P2 = P(i+1,:);
            v = (P2 - P1) / norm( P2-P1 );
            % skip small segments
            if norm(P1-P2)<1e-5
                continue;
            end
            [TH,PHI] = cart2sph(v(1),v(2),v(3));
            % Instructions are executed from bottom up
            fprintf( fid, '\tCoordSysTransform "world"\n' );
            fprintf( fid, '\tTransform [%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f]\n', modelview );
            fprintf( fid, '\tTranslate %f %f %f\n', P1 );
            fprintf( fid, '\tRotate %f 0 0 1 \n', TH*180/pi - 180);
            fprintf( fid, '\tRotate %f 0 1 0 \n', PHI*180/pi );
            fprintf( fid, '\tRotate %f 0 1 0 \n', -90 ); %align with x>0
            fprintf( fid, '\tShape "sphere" "float radius" [%f]\n', samplesize);
            fprintf( fid, '\tShape "cylinder" "float radius" [%f] "float zmin" [0] "float zmax" [%f] \n\n', linewidth, norm(P2-P1));
        end
    fprintf( fid, 'AttributeEnd\n\n' );
    
elseif strcmp( TYPE, 'end' )
    p.addRequired('fid', @isnumeric);
    p.parse( varargin{:} );
    fid = p.Results.fid;
    
    fprintf( fid, 'WorldEnd\n' );
    fclose( fid );
elseif strcmp( TYPE, 'render' )
    if ismac()
        p.addRequired('filename', @ischar);
        p.parse( varargin{:} );
        filename = p.Results.filename;

        system(['pbrt ', filename, '.pbrt']);
        system(['open ', filename, '.exr']);    
    else
        error('"render" available only on mac systems');
    end
end

end %--- function end ---%