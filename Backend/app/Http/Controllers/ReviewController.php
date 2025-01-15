<?php

namespace App\Http\Controllers;

use App\Models\Review;
use Illuminate\Http\Request;
use Exception;

class ReviewController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        try {
            $data = Review::all();
            return response()->json([
                "status" => true,
                "message" => "Get Successful",
                "data" => $data
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {   
        $request->validate([
            'rating_film' => 'required|numeric|min:1|max:5', // Pastikan rating antara 1 hingga 5
            'komentar' => 'required|string', // Review harus ada
            'id_film' => 'nullable|integer', // id_film bisa null, jika tidak ada
            'id_user' => 'nullable|integer',
            'id_tiket' => 'nullable|integer',
        ]);

        try {
            // Menyimpan data review ke database
            $data = Review::create($request->all());

            // Mengirimkan response jika berhasil
            return response()->json([
                "status" => true,
                "message" => "Review berhasil dikirim!",
                "data" => $data
            ], 200);
        } catch (Exception $e) {
            // Menangani error jika terjadi kesalahan
            return response()->json([
                "status" => false,
                "message" => "Terjadi kesalahan",
                "data" => $e->getMessage()
            ], 400);
        }
    }


    /**
     * Display the specified resource.
     */
    public function show(Review $review)
    {
        //
        try {
            return response()->json([
                "status" => true,
                "message" => "Get Successful",
                "data" => $review
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "data" => $e->getMessage()
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
            'rating' => 'required|numeric|min:0|max:10',
            'review' => 'required|string',
        ]);

        try {
            $review = Review::find($id);
            $review->update($request->all());
            return response()->json([
                "status" => true,
                "message" => "Get Successful",
                "data" => $review
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function getReviewsByFilm($id_film)
    {   
        // Ambil review berdasarkan id_film
        $reviews = Review::join('users', 'reviews.id_user', '=', 'users.id')
                ->select('reviews.*', 'users.nama', 'users.foto')
                ->where('id_film', $id_film)->get();

        return response()->json([
            'data' => $reviews,
        ], 200);
    }

    public function getReviewsByUser($id_user)
    {   
        // Ambil review berdasarkan id_film
        $reviews = Review::join('users', 'reviews.id_user', '=', 'users.id')
                ->join('films', 'reviews.id_film', '=', 'films.id')
                ->select('reviews.*', 'users.nama', 'users.foto', 'films.nama_film')
                ->where('id_user', $id_user)->get();

        return response()->json([
            'data' => $reviews,
        ], 200);
    }

    public function getReviewsByTicket($id)
    {   
        // Ambil review berdasarkan id_film
        $reviews = Review::join('users', 'reviews.id_user', '=', 'users.id')
                ->select('reviews.*', 'users.nama', 'users.foto')
                ->where('id_tiket', $id)->first();

        return response()->json([
            'data' => $reviews,
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        //
        try {
            $review = Review::find($id);
            $review->delete();
            return response()->json([
                "status" => true,
                "message" => "Get Successful",
                "data" => $review
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function getAverageRating($id_film)
    {   
        // Ambil review berdasarkan id_film
        $reviews = Review::where('id_film', $id_film)->get();

        $rerata = Review::where('id_film', $id_film)
        ->avg('rating_film');

        $rerata = floatval($rerata);

        return response()->json([
            "success" => true,
            'rerata' => $rerata ?? 0.0,
        ], 200);
    }
}
