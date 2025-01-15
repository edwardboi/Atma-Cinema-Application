<?php

namespace App\Http\Controllers;

use App\Models\Tiket;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Exception;

class TiketController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try{
            $data = Tiket::all();
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
        try{
            $data = Tiket::create($request->all());
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
     * Display the specified resource.
     */
    public function show($id)
    {
        try{
            $data = Tiket::join('pemesanans', 'tikets.id_pemesanan', '=', 'pemesanans.id')
                ->join('films', 'pemesanans.id_film', '=', 'films.id')
                ->join('jadwals', 'pemesanans.id_jadwal', '=', 'jadwals.id')
                ->join('jam_tayangs', 'pemesanans.id_jamtayang', '=', 'jam_tayangs.id')
                ->join('studios', 'jam_tayangs.id_studio', '=', 'studios.id')
                ->join('jams', 'jam_tayangs.id_jam', '=', 'jams.id')
                ->select('tikets.*', 'pemesanans.harga', 'pemesanans.jumlah_kursi', 
                                'pemesanans.id_film', 'pemesanans.id_jadwal', 'pemesanans.id_jamtayang', 
                                'pemesanans.id_user', 'films.nama_film', 'films.gambar_film', 
                                'jadwals.tanggal_tayang', 'studios.tipe_studio', 'studios.harga as studioHarga', 'jams.jam')
                ->where('tikets.id', $id)
                ->first();

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
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        try{
            $data = Tiket::find($id);
            $data->update($request->all());
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
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try{
            $data = Tiket::find($id);
            $data->delete();
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

    public function showTiketByUser($id) 
    {
        try {
            $data = Tiket::join('pemesanans', 'tikets.id_pemesanan', '=', 'pemesanans.id')
                ->join('films', 'pemesanans.id_film', '=', 'films.id')
                ->join('jadwals', 'pemesanans.id_jadwal', '=', 'jadwals.id')
                ->join('jam_tayangs', 'pemesanans.id_jamtayang', '=', 'jam_tayangs.id')
                ->join('studios', 'jam_tayangs.id_studio', '=', 'studios.id')
                ->join('jams', 'jam_tayangs.id_jam', '=', 'jams.id')
                ->select('tikets.*', 'pemesanans.harga', 'pemesanans.jumlah_kursi', 
                                'pemesanans.id_film', 'pemesanans.id_jadwal', 'pemesanans.id_jamtayang', 
                                'pemesanans.id_user', 'films.nama_film', 'films.gambar_film', 
                                'jadwals.tanggal_tayang', 'studios.tipe_studio', 'studios.harga as studioHarga', 'jams.jam')
                ->where('pemesanans.id_user', $id)
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

}
