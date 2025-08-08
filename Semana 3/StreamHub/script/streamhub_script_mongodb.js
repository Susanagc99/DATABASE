// Colección usuarios
db.usuarios.insertMany([
  {
    _id: "user1",
    nombre: "Ana Pérez",
    email: "ana@email.com",
    pais: "Colombia",
    generos_preferidos: ["Drama", "Aventura"],
    historial: [
      {
        contentId: "movie1",
        vistoEn: new Date("2025-07-01T10:00:00Z"),
        progreso: 95
      }
    ],
    createdAt: new Date("2025-06-30T08:30:00Z")
  },
  {
    _id: "user2",
    nombre: "Juan Gómez",
    email: "juan@email.com",
    pais: "México",
    generos_preferidos: ["Comedia", "Romance"],
    historial: [],
    createdAt: new Date("2025-05-12T11:00:00Z")
  },
  {
    _id: "user3",
    nombre: "Luisa Martínez",
    email: "luisa@email.com",
    pais: "Colombia",
    generos_preferidos: ["Thriller", "Misterio"],
    historial: [
      {
        contentId: "serie1",
        vistoEn: new Date("2025-07-02T20:00:00Z"),
        progreso: 40
      }
    ],
    createdAt: new Date("2025-07-01T14:15:00Z")
  }
]);

// Colección contenidos
db.contenidos.insertMany([
  {
    _id: "movie1",
    tipo: "pelicula",
    titulo: "El Viaje",
    duracion: 130,
    anio: 2021,
    generos: ["Drama", "Aventura"],
    reparto: ["Ana López", "Carlos Ruiz"],
    createdAt: new Date("2025-04-20T10:00:00Z")
  },
  {
    _id: "movie2",
    tipo: "pelicula",
    titulo: "Risas y Café",
    duracion: 95,
    anio: 2023,
    generos: ["Comedia", "Romance"],
    reparto: ["Actor X", "Actriz Y"],
    createdAt: new Date("2025-03-15T09:00:00Z")
  },
  {
    _id: "serie1",
    tipo: "serie",
    titulo: "Misterios de la Ciudad",
    anio: 2019,
    generos: ["Misterio", "Thriller"],
    reparto: ["Actor A", "Actriz B"],
    temporadas: [
      {
        numero: 1,
        episodios: [
          { episodeId: "s1e1", numero: 1, titulo: "Noche fría", duracion: 42 },
          { episodeId: "s1e2", numero: 2, titulo: "Huella", duracion: 45 }
        ]
      }
    ],
    createdAt: new Date("2025-02-10T08:00:00Z")
  }
]);

// Colección listas
db.listas.insertMany([
  {
    _id: "l1",
    ownerId: "user1",
    nombre: "Favoritas",
    createdAt: new Date("2025-07-07T09:00:00Z"),
    items: ["movie1", "serie1"]
  },
  {
    _id: "l2",
    ownerId: "user2",
    nombre: "Para ver este fin",
    createdAt: new Date("2025-07-08T12:00:00Z"),
    items: ["movie2"]
  }
]);

// Colección valoraciones
db.valoraciones.insertMany([
  {
    _id: "r1",
    userId: "user1",
    contentId: "movie1",
    puntuacion: 4,
    comentario: "Buena película",
    fecha: new Date("2025-07-05T14:00:00Z")
  },
  {
    _id: "r2",
    userId: "user2",
    contentId: "movie1",
    puntuacion: 5,
    comentario: "Me encantó",
    fecha: new Date("2025-07-06T17:30:00Z")
  },
  {
    _id: "r3",
    userId: "user3",
    contentId: "serie1",
    puntuacion: 3,
    comentario: "Entretenida",
    fecha: new Date("2025-07-02T10:00:00Z")
  }
]);



// Consultas básicas


// Películas con más de 120 min
db.contenidos.find({ duracion: { $gt: 120 } });

// Usuarios que han visto más de 0 contenidos
db.usuarios.find({ "historial.0": { $exists: true } });

// Contenidos del género Aventura
db.contenidos.find({ generos: "Aventura" });

// Buscar usuarios por nombre con regex (ej. que contenga "an")
db.usuarios.find({ nombre: { $regex: "an", $options: "i" } });



// Actualizar y eliminar


// Cambiar puntuación de una valoración
db.valoraciones.updateOne(
  { _id: "r1" },
  { $set: { puntuacion: 4.5, updatedAt: new Date() } }
);

// Eliminar una lista por nombre
db.listas.deleteOne({ nombre: "Para ver este fin" });



// Indices

// Indice por título
db.contenidos.createIndex({ titulo: 1 });

// Indice por género
db.contenidos.createIndex({ generos: 1 });

// Ver índices
db.contenidos.getIndexes();



// Agregaciones


// Promedio de calificación por contenido
db.valoraciones.aggregate([
  {
    $group: {
      _id: "$contentId",
      promedio: { $avg: "$puntuacion" },
      totalValoraciones: { $sum: 1 }
    }
  }
]);

// Número de contenidos vistos por usuario
db.usuarios.aggregate([
  {
    $project: {
      nombre: 1,
      totalVistos: { $size: "$historial" }
    }
  }
]);

// Géneros más populares
db.contenidos.aggregate([
  { $unwind: "$generos" },
  { $group: { _id: "$generos", total: { $sum: 1 } } },
  { $sort: { total: -1 } }
]);
