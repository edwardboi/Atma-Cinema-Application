<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Jam;
use Illuminate\Http\Request;

class JamController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try{
            $data = Jam::all();
            return response()->json([
                "status" => true,
                "message" => "Get Successful",
                "data" => $data
            ], 200);
        }
        catch(Exception $e){
            return response()->json([
                "status" => false,
                "message"=> "Something went wrong",
                "data"=>$e->getMessage()
            ], 400);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(Jam $jam)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Jam $jam)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Jam $jam)
    {
        //
    }
}
