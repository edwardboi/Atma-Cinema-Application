<?php

namespace App\Http\Controllers;

use App\Models\Film;
use Illuminate\Http\Request;
use Exception;

class FilmController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $films = Film::all();
            return response()->json([
                "status" => true,
                "message" => "Films retrieved successfully",
                "data" => $films
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve films',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'nama_film' => 'required|string|max:255',
            'durasi' => 'required|integer',
            'genre' => 'required|string|max:255',
            'sinopsis' => 'required|string',
            'rating_film' => 'required|min:0|max:10',
            'rating_usia' => 'required',
            'cast' => 'required|string',
            'gambar_film' => 'required|string',
            'status' => 'required|string'
        ]);

        try {
            $film = Film::create($validatedData);
            return response()->json([
                "status" => true,
                "message" => "Film created successfully",
                "data" => $film
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to create film',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Film $film)
    {
        try {
            return response()->json([
                "status" => true,
                "message" => "Film retrieved successfully",
                "data" => $film
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve film',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        //
        $validatedData = $request->validate([
            'nama_film' => 'required|string|max:255',
            'durasi' => 'required|integer',
            'genre' => 'required|string|max:255',
            'sinopsis' => 'required|string',
            'rating_film' => 'required|numeric|min:0|max:10',
            'rating_usia' => 'required',
            'cast' => 'required|string',
            'gambar_film' => 'required|string',
            'status' => 'required|string'
        ]);
    
        try {
            $film = Film::find($id);
            $film->update($validatedData);
            return response()->json([
                "status" => true,
                "message" => "Film updated successfully",
                "data" => $film
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to update film',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {
            $film = Film::find($id);
            $film->delete();
            return response()->json([
                "status" => true,
                "message" => "Film deleted successfully",
                "data" => $film
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to delete film',
                'data' => $e->getMessage()
            ], 400);
        }
    }
}
