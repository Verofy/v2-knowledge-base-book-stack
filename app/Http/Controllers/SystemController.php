<?php

namespace BookStack\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SystemController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct() {
        // ...
    }

    /**
     * System health-check control route.
     */
    public function healthCheck()
    {
        // Check main DB connection.
//        if (DB::connection('mysql')->getDatabaseName())
//        {
//            echo "Connected successfully to the database: " . DB::connection('mysql')->getDatabaseName() . ".<br />";
//        }

        // Return 200 OK.
        return;
    }
}
