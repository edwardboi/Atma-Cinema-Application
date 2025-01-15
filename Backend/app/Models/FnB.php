<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FnB extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $table ="fnbs";
    protected $primaryKey = 'id_fnb';

    protected $fillable = [
        'nama_menu',
        'jenis',
        'harga',
        'gambar'
    ];
}
