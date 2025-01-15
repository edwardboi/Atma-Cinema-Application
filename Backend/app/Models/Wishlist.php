<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Wishlist extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $fillable= [
        'id_film',
        'id_user',
    ];

    public function film(){
        return $this->belongsTo(Film::class, 'id');
    }

    public function user(){
        return $this->belongsTo(User::class);
    }
}
