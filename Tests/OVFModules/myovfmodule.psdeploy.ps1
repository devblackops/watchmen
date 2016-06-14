Deploy My-OVF-Modules {        
    By PSGalleryModule MyOVFModule {
        FromSource '.\MyOVFModule\'
        To 'Artifactory'
        WithOptions @{
            ApiKey = $env:ARTIFACTORY_API_KEY
        }
    }       
}
