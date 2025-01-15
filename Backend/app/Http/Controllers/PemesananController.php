<?php

namespace App\Http\Controllers;

use App\Models\Pemesanan;
use App\Models\Studio;
use Illuminate\Http\Request;
use Exception;

class PemesananController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try{
            $data = Pemesanan::all();
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
        $request->validate([
            'id_film' => 'required', 
            'id_jadwal' => 'required', 
            'id_jamtayang' => 'required', 
            'id_user' => 'required',
            'harga' => 'required', 
            'jumlah_kursi' => 'required'
        ]);

        try{
            $data = Pemesanan::create($request->all());
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
            $data = Pemesanan::join('films', 'pemesanans.id_film', '=', 'films.id')
            ->join('jadwals', 'pemesanans.id_jadwal', '=', 'jadwals.id')
            ->join('jam_tayangs', 'pemesanans.id_jamtayang', '=', 'jam_tayangs.id')
            ->join('studios', 'jam_tayangs.id_studio', '=', 'studios.id') 
            ->join('jams', 'jam_tayangs.id_jam', '=', 'jams.id') 
            ->select('pemesanans.*', 'films.nama_film', 'jadwals.tanggal_tayang', 'studios.tipe_studio', 'studios.harga as studioHarga', 'jams.jam', )
            ->where('pemesanans.id', $id)
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
            $data = Pemesanan::find($id);
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
            $data = Pemesanan::find($id);
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

    public function getSisaKapasitas($id_jadwal, $id_studio, $id_jamtayang, $id_film)
    {
        $kapasitas = Studio::where('id', $id_studio)->value('kapasitas');

        $kursiTerpakai = Pemesanan::where('pemesanans.id_jadwal', '=', $id_jadwal)
            ->where('pemesanans.id_film', $id_film)
            // ->where('jadwals.id', $id_jadwal)
            ->where('pemesanans.id_jamtayang', $id_jamtayang)
            ->sum('pemesanans.jumlah_kursi');

        $sisaKapasitas = $kapasitas - $kursiTerpakai;

        return response()->json([
            'id_studio' => $id_studio,
            'id_jamtayang' => $id_jamtayang,
            'sisa_kapasitas' => $sisaKapasitas > 0 ? $sisaKapasitas : 0, 
        ]);
    }


}
