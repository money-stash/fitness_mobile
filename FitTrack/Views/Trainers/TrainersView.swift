import SwiftUI

struct TrainersView: View {
    @EnvironmentObject var store: AppStore

    private var upcoming: [Booking] {
        store.bookings
            .filter { $0.date >= Date().startOfDay }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if !upcoming.isEmpty {
                        bookingsSection
                    }
                    Text(L("trainers.our"))
                        .font(.headline)
                    ForEach(SeedData.trainers) { trainer in
                        NavigationLink {
                            TrainerDetailView(trainer: trainer)
                        } label: {
                            TrainerCard(trainer: trainer)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(L("trainers.title"))
        }
    }

    private var bookingsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L("trainers.myBookings"))
                .font(.headline)
            ForEach(upcoming) { booking in
                if let trainer = store.trainer(booking.trainerID) {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.title3)
                            .foregroundStyle(Color.named(trainer.colorName))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(trainer.name)
                                .font(.subheadline.weight(.semibold))
                            Text(booking.date.timeLabel)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if !booking.note.isEmpty {
                                Text(booking.note)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        Spacer()
                        Button(role: .destructive) {
                            store.bookings.removeAll { $0.id == booking.id }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .card()
                }
            }
        }
    }
}

struct TrainerCard: View {
    let trainer: Trainer

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.named(trainer.colorName).opacity(0.18))
                Image(systemName: trainer.icon)
                    .font(.title2)
                    .foregroundStyle(Color.named(trainer.colorName))
            }
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text(trainer.name)
                    .font(.subheadline.weight(.semibold))
                Text(trainer.specialty)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 6) {
                    StarsView(rating: trainer.rating)
                    Text("\(trainer.rating.clean) (\(trainer.reviewsCount))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(trainer.pricePerHour) ₴")
                    .font(.subheadline.bold())
                Text(L("trainer.perHour"))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .card()
    }
}

// MARK: - Trainer Profile

struct TrainerDetailView: View {
    @EnvironmentObject var store: AppStore
    let trainer: Trainer
    @State private var showBooking = false
    @State private var bookedAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.named(trainer.colorName).opacity(0.18))
                    Image(systemName: trainer.icon)
                        .font(.system(size: 44))
                        .foregroundStyle(Color.named(trainer.colorName))
                }
                .frame(width: 100, height: 100)

                VStack(spacing: 4) {
                    Text(trainer.name)
                        .font(.title2.bold())
                    Text(trainer.specialty)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 6) {
                        StarsView(rating: trainer.rating)
                        Text(L("trainer.reviewsInline", trainer.rating.clean, trainer.reviewsCount))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 12) {
                    infoTile(value: "\(trainer.yearsExp)", label: L("trainer.yearsExp"))
                    infoTile(value: "\(trainer.pricePerHour) ₴", label: L("trainer.perHour"))
                    infoTile(value: "\(trainer.reviewsCount)", label: L("trainer.reviewsLabel"))
                }

                FlowTags(tags: trainer.tags, color: Color.named(trainer.colorName))

                VStack(alignment: .leading, spacing: 6) {
                    Text(L("trainer.about"))
                        .font(.headline)
                    Text(trainer.bio)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .card()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(L("trainer.single"))
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                showBooking = true
            } label: {
                Label(L("trainer.book"), systemImage: "calendar.badge.plus")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .sheet(isPresented: $showBooking) {
            BookingSheet(trainer: trainer) {
                bookedAlert = true
            }
            .presentationDetents([.medium])
        }
        .alert(L("booking.doneTitle"), isPresented: $bookedAlert) {
            Button(L("common.ok")) {}
        } message: {
            Text(L("booking.doneMsg"))
        }
    }

    private func infoTile(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .card()
    }
}

/// Simple wrapping tag layout.
struct FlowTags: View {
    let tags: [String]
    var color: Color = .brand

    var body: some View {
        HStack {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption.weight(.medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(color.opacity(0.12))
                    .foregroundStyle(color)
                    .clipShape(Capsule())
            }
        }
    }
}

// MARK: - Trainer Booking

struct BookingSheet: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) private var dismiss

    let trainer: Trainer
    var onBooked: () -> Void

    @State private var date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(L("booking.datetime")) {
                    DatePicker(L("booking.when"), selection: $date, in: Date()...,
                               displayedComponents: [.date, .hourAndMinute])
                }
                Section(L("booking.comment")) {
                    TextField(L("booking.comment.ph"), text: $note, axis: .vertical)
                        .lineLimit(2...4)
                }
                Section {
                    LabeledContent(L("booking.cost"), value: L("booking.costValue", trainer.pricePerHour))
                }
            }
            .navigationTitle(L("booking.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L("common.cancel")) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L("booking.book")) {
                        store.bookings.append(Booking(trainerID: trainer.id, date: date, note: note))
                        dismiss()
                        onBooked()
                    }
                    .bold()
                }
            }
        }
    }
}
