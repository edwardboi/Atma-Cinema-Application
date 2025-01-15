<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Pemesanan extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $fillable = [
        'id_jamtayang',
        'id_film',
        'id_jadwal',
        'id_user',
        'jumlah_kursi',
        'harga'
    ];

    public function jamtayang(){
        return $this->belongsTo(JamTayang::class);
    }

    public function film(){
        return $this->belongsTo(Film::class);
    }

    public function jadwal(){
        return $this->belongsTo(Jadwal::class);
    }

    public function user(){
        return $this->belongsTo(User::class);
    }

    public function pemesanan(){
        return $this->hasOne(Tiket::class);
    }
}
