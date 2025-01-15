<?php

namespace App\Http\Controllers;

use App\Models\FnB;
use Illuminate\Http\Request;
use Exception;

class FnBController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        try {
            $fnbItems = FnB::all();
            return response()->json([
                "status" => true,
                "message" => "FnB items retrieved successfully",
                "data" => $fnbItems
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve FnB items',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'nama_menu' => 'required|string|max:255',
            'jenis' => 'required|string|max:255',
            'harga' => 'required',
            'gambar' => 'required|string|max:255'
        ]);

        try {
            $fnbItem = FnB::create($request->all());
            return response()->json([
                "status" => true,
                "message" => "FnB item created successfully",
                "data" => $fnbItem
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to create FnB item',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(FnB $fnB)
    {
        //
        try {
            return response()->json([
                "status" => true,
                "message" => "FnB item retrieved successfully",
                "data" => $fnB
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve FnB item',
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
        $request->validate([
            'nama_menu' => 'required|string|max:255',
            'jenis' => 'required|string|max:255',
            'harga' => 'required',
            'gambar' => 'required|string|max:255'
        ]);

        try {
            $fnB = FnB::find($id);
            $fnB->update($request->all());
            return response()->json([
                "status" => true,
                "message" => "FnB item updated successfully",
                "data" => $fnB
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to update FnB item',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        //
        try {
            $fnB = FnB::find($id);
            $fnB->delete();
            return response()->json([
                "status" => true,
                "message" => "FnB item deleted successfully",
                "data" => $fnB
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to delete FnB item',
                'data' => $e->getMessage()
            ], 400);
        }
    }

}
