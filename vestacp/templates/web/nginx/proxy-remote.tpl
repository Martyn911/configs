server {
    listen	%ip%:%web_port%;
    server_name %domain_idn% %alias_idn%;
#    access_log  /var/log/nginx/%domain%-access.log combined;
    error_log  /var/log/nginx/%domain%-error.log error;

    include %home%/%user%/conf/web/snginx.%domain%.conf*;

    #if ($scheme = http) {
    #    return 301 https://%domain_idn%$request_uri;
    #}

    if ($host = www.%domain_idn%) {
        return 301 http://%domain_idn%$request_uri;
    }

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header CF-Connecting-IP $remote_addr;

        proxy_pass http://%ip%:%web_port%;
    }

    location /error/ {
        alias   %home%/%user%/web/%domain%/document_errors/;
    }

    location ~ /\.ht    {return 404;}
    location ~ /\.svn/  {return 404;}
    location ~ /\.git/  {return 404;}
    location ~ /\.hg/   {return 404;}
    location ~ /\.bzr/  {return 404;}
}
