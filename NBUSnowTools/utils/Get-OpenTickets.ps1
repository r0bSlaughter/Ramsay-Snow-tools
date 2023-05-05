function Get-OpenTickets {
    <#
    .SYNOPSIS
        Retrieves servicenow records.
    
    .DESCRIPTION
        Retrieve records from any table with the option to filter, sort, and choose fields.
        Given you know the table name, you shouldn't need any other 'Get-' function.
        Paging is supported with -First, -Skip, and -IncludeTotalCount.
    
    .PARAMETER Table
        Name of the table to be queried, by either table name or class name
    
    .PARAMETER Properties
        Limit the fields returned to this list
    
    .PARAMETER Filter
        Array or multidimensional array of fields and values to filter on.
        Each array should be of the format @(field, comparison operator, value) separated by a join, either 'and', 'or', or 'group'.
        For a complete list of comparison operators, see $script:ServiceNowOperator and use Name in your filter.
        See the examples.
        Also, see https://docs.servicenow.com/bundle/quebec-platform-user-interface/page/use/common-ui-elements/reference/r_OpAvailableFiltersQueries.html
        for how to represent date values with javascript.
    
    .PARAMETER Sort
        Array or multidimensional array of fields to sort on.
        Each array should be of the format @(field, asc/desc).
    
    .PARAMETER DisplayValues
        Option to display values for reference fields.
        'false' will only retrieve the reference
        'true' will only retrieve the underlying value
        'all' will retrieve both.  This is helpful when trying to translate values for a query.
    
    .PARAMETER Connection
        Azure Automation Connection object containing username, password, and URL for the ServiceNow instance
    
    .PARAMETER ServiceNowSession
        ServiceNow session created by New-ServiceNowSession.  Will default to script-level variable $ServiceNowSession.
    
    .EXAMPLE
        Get-MyWork -Table incident -Filter @('state', '-eq', '1'), 'or', @('short_description','-like', 'powershell')
        Get incident records where state equals New or short description contains the word powershell
    
    .EXAMPLE
        $filter = @('state', '-eq', '1'),
                    'and',
                  @('short_description','-like', 'powershell'),
                    'group',
                  @('state', '-eq', '2')
        PS > Get-MyWork -Table incident -Filter $filter
        Get incident records where state equals New and short description contains the word powershell or state equals In Progress.
        The first 2 filters are combined and then or'd against the last.
    
    .EXAMPLE
        Get-MyWork -Table incident -Filter @('state', '-eq', '1') -Sort @('opened_at', 'desc'), @('state')
        Get incident records where state equals New and first sort by the field opened_at descending and then sort by the field state ascending
    
    .EXAMPLE
        Get-MyWork -Table 'change request' -Filter @('opened_at', '-ge', 'javascript:gs.daysAgoEnd(30)')
        Get change requests opened in the last 30 days.  Use class name as opposed to table name.
    
    .EXAMPLE
        Get-MyWork -Table 'change request' -First 100 -IncludeTotalCount
        Get all change requests, paging 100 at a time.
    
    .INPUTS
        None
    
    .OUTPUTS
        System.Management.Automation.PSCustomObject
    
    .LINK
        https://docs.servicenow.com/bundle/quebec-platform-user-interface/page/use/common-ui-elements/reference/r_OpAvailableFiltersQueries.html
    #>
        [OutputType([System.Management.Automation.PSCustomObject])]
        [CmdletBinding(DefaultParameterSetName = 'SessionFilter',SupportsPaging)]
        param(
            # Table name 
            [Parameter(Mandatory = $false,HelpMessage = "Table to search")]
            [ValidateSet("Catalog_task","Problem","Incident","Change Request","Request item","Request","Change task")]
            [string]
            $Table,

            
    
            # Filter
            [Parameter(ParameterSetName = 'AutomationFilter')]
            [Parameter(ParameterSetName = 'SessionFilter')]
            [Parameter(HelpMessage = "Review Help - get-help Get-OpenTickets")]
            [System.Collections.ArrayList]
            $Filter,
    
            # Fields to return
            [Parameter()]
            [Alias('Fields')]
            [string[]]$Properties
    
        )

                    $svnsgroups = @("Infrastructure Services - IT Systems","Infrastructure Services - IT Backups")
            

        if (!$Table){Write-Log -Message "Table not specificed - checking all ticket queues." -errorLevel Message 
        $tablelist = @("sc_task","problem","incident","change_request","sc_req_item","sc_request","change_task")
         foreach ($table in $tablelist) {Get-ServiceNowRecord @PSBoundParameters -Filter $Filter}
                    }

        
        if (!$Filter) {
            foreach ($snowgroup in $svnsgroups){
            Write-Warning -Message "Using Default Filter - Current Username - Open Items"
            $Filter = @('assigned_to','-like',''),'and',@('state','-lt',3),'and',@('assignment_group','-like',"$($snowgroup)")}
            try {
                $tasklst = Get-ServiceNowRecord @PSBoundParameters -Filter $Filter
            } catch {
                Write-Warning "Hmm.. that doesn't appear to have been successful. Blond Moment.? $($_.Exception.Message)" }
        } else {
            try { $tasklst = Get-ServiceNowRecord @PSBoundParameters }
            catch {
                Write-Warning "Oops. looks like something stuffed up..:   $($_.Exception.Message)"
            }
            #Get-ServiceNowTableEntry -Table sc_task -MatchContains @{assigned_to="$global:username"}
        }
        $global:tickets = $tasklst
    
        return $tasklst
    
    
    }