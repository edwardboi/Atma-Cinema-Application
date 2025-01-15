<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Jadwal extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $fillable = [
        'tanggal_tayang',
    ];

    public function pemesanan()
    {
        return $this->hasMany(Pemesanan::class);
    }
}
