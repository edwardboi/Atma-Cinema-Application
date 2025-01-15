<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Film extends Model
{
    use HasFactory;
    
    public $timestamps = false;

    // protected $primaryKey = 'id_film';
    protected $fillable = [
        'nama_film',
        'durasi',
        'genre',
        'sinopsis',
        'rating_film',
        'rating_usia',
        'cast',
        'gambar_film',
        'status'
    ];

    public function review()
    {
        return $this->hasMany(Review::class);
    }

    public function pemesanan()
    {
        return $this->hasMany(Pemesanan::class);
    }

    public function wishlist()
    {
        return $this->hasOne(Wishlist::class);
    }
}
