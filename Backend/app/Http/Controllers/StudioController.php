<?php

namespace App\Http\Controllers;

use App\Models\Studio;
use Illuminate\Http\Request;
use Exception;

class StudioController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        try {
            $studios = Studio::all();
            return response()->json([
                "status" => true,
                "message" => "Studios retrieved successfully",
                "data" => $studios
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve studios',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
        $validatedData = $request->validate([
            'kapasitas' => 'required|integer',
            'tipe_studio' => 'required|string|max:255',
            'jam_tayang' => 'required|string',
            'harga' => 'required',
        ]);

        try {
            $studio = Studio::create($validatedData);
            return response()->json([
                "status" => true,
                "message" => "Studio created successfully",
                "data" => $studio
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to create studio',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Studio $studio)
    {
        //
        try {
            return response()->json([
                "status" => true,
                "message" => "Studio retrieved successfully",
                "data" => $studio
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve studio',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id_studio)
    {
        //
        $request->validate([
            'kapasitas' => 'required|integer',
            'tipe_studio' => 'required|string|max:255',
            'jam_tayang' => 'required|string',
            'harga' => 'required',
        ]);

        try {
            $studio = Studio::where('id_studio', $id_studio)->first();
            $studio->update($request->all());
            return response()->json([
                "status" => true,
                "message" => "Studio updated successfully",
                "data" => $studio
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to update studio',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Studio $studio)
    {
        //
        try {
            $studio->delete();
            return response()->json([
                "status" => true,
                "message" => "Studio deleted successfully",
                "data" => $studio
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to delete studio',
                'data' => $e->getMessage()
            ], 400);
        }
    }
}
