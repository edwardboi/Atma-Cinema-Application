<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;

use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    use HasFactory, HasApiTokens;

    public $timestamps = false;
    protected $table = "users";
    protected $primaryKey = "id";

    protected $fillable = [
        'nama',
        'email',
        'password',
        'telp',
        'tanggal_lahir',
        'foto'
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
        return $this->hasMany(Wishlist::class);
    }


}
