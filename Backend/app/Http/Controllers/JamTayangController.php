<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\JamTayang;
use Illuminate\Http\Request;

class JamTayangController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try{
            // $data = JamTayang::with(['studio', 'jam'])->get();

            $data = JamTayang::join('studios', 'jam_tayangs.id_studio', '=', 'studios.id')
                ->join('jams', 'jam_tayangs.id_jam', '=', 'jams.id')
                ->select('jam_tayangs.*', 'studios.harga', 'studios.kapasitas', 'studios.tipe_studio', 'jams.jam')
                ->get();

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

    public function findByStudioId($id)
    {
        try {
            $data = JamTayang::join('studios', 'jam_tayangs.id_studio', '=', 'studios.id')
                ->join('jams', 'jam_tayangs.id_jam', '=', 'jams.id')
                ->where('jam_tayangs.id_studio', '=', $id)
                ->select('jam_tayangs.*', 'studios.harga', 'studios.kapasitas', 'studios.tipe_studio', 'jams.jam')
                ->get();

            if ($data->isEmpty()) {
                return response()->json([
                    "status" => false,
                    "message" => "Data not found for studio ID: $id",
                ], 404);
            }

            return response()->json([
                "status" => true,
                "message" => "Get Successful",
                "data" => $data,
            ], 200);

        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "error" => $e->getMessage(),
            ], 400);
        }
        
    }

    

}