function Assert-InWatchmen {
    param ($Command)

    # Verify we aren't calling the command completly outside of a Watchmen file
    if ($null -eq $script:Watchmen) {
        throw "The command [$Command] may only be used inside a Watchmen configuration file."
    }

    # WatchmenOptions
    if ($script:Watchmen.InConfig) {
        if ($script:Watchmen.InNotifies) {
            if ($command -notin $script:CommandFences.Notifies) {
                throw "The Watchmen command [$Command] may only be used inside a Notifies block."
            }
        } else {
            if ($command -notin $script:CommandFences.WatchmenOptions) {
                throw "The Watchmen command [$Command] may only be used inside a WatchmenOptions block."
            }
        }
    }

    # WatchmenTest
    if ($script:WatchMen.InTest) {

        if ($script:Watchmen.InNotifies) {
            if ($command -notin $script:CommandFences.Notifies) {
                throw "The Watchmen command [$Command] may only be used inside a Notifies block."
            }
        } else {
            if ($command -notin $script:CommandFences.WatchmenTest) {
                throw "The Watchmen command [$Command] may only be used inside a WatchmenTest block."
            }
        }
    }

    # Notifies
    if ($script:WatchMen.InNotifies) {
        if ($command -notin $script:CommandFences.Notifies) {
            throw "The Watchmen command [$Command] may only be used inside a Notifies block."
        }
    }
}
