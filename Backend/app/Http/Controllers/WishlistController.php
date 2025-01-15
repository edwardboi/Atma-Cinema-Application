<?php

namespace App\Http\Controllers;

use App\Models\Wishlist;
use Illuminate\Http\Request;
use Exception;

class WishlistController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try{
            // $data = Wishlist::all();
            $data = Wishlist::join('films', 'wishlists.id_film', '=', 'films.id')
            ->join('users', 'wishlists.id_user', '=', 'users.id')
            ->select(
                'wishlists.id as wishlist_id',      
                'films.id as film_id',               
                'users.id as user_id',                 
                'wishlists.id_film',                   
                'wishlists.id_user',                  
                'films.nama_film',                     
                'films.durasi',                       
                'films.genre',                        
                'films.sinopsis',                     
                'films.rating_film',                   
                'films.rating_usia',                   
                'films.cast',                         
                'films.gambar_film',                   
                'films.status',             
            )
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

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'id_film' => 'nullable|integer', // id_film bisa null, jika tidak ada
            'id_user' => 'nullable|integer', // id_user bisa null, jika tidak ada
        ]);
        try{
            $data = Wishlist::create($request->all());
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
            $data = Wishlist::find($id);
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
            $data = Wishlist::find($id);
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
            $data = Wishlist::find($id);
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

    public function fetchWishlistByuser($id)
    {
        try{
            // $data = Wishlist::all();
            $data = Wishlist::join('films', 'wishlists.id_film', '=', 'films.id')
            ->join('users', 'wishlists.id_user', '=', 'users.id')
            ->select(
                'wishlists.id as wishlist_id',      
                'films.id as film_id',               
                'users.id as user_id',                 
                'wishlists.id_film',                   
                'wishlists.id_user',                  
                'films.nama_film',                     
                'films.durasi',                       
                'films.genre',                        
                'films.sinopsis',                     
                'films.rating_film',                   
                'films.rating_usia',                   
                'films.cast',                         
                'films.gambar_film',                   
                'films.status',             
            )
            ->where('wishlists.id_user', $id)
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

