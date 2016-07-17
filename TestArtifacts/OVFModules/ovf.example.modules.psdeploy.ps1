Deploy My-OVF-Modules {

    By FileSystem OVF.Example1 {
        FromSource '.\OVF.Example1\'
        To "$env:programfiles\WindowsPowerShell\Modules\OVF.Example1"
    }

    By FileSystem OVF.Example2 {
        FromSource '.\OVF.Example2\'
        To "$env:programfiles\WindowsPowerShell\Modules\OVF.Example2"
    }
}
