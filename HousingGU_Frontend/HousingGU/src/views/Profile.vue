<template>
	<div class="page-container">
		<div class="container-fluid h-100 px-0">
			<div class="row h-100 mx-0">
				<div class="col-12 col-md-4 h-80">
					<div class="card h-80 mt-1">
						<img :src="profileImgURL" alt="Profile Picture" class="card-img-top" />
						<div class="card-body">
							<h5 class="card-title">{{ userInfo.userName }}</h5>
							<p class="card-text">{{ desc }}</p>
							<button class="btn btn-primary mr-1" @click="router.push('/roomatePreference')">Edit Preferance</button>
							<button class="btn btn-primary" @click="editProfile">Edit Profile</button>
							<button class="btn btn-primary" @click="showPreferencesBool">View Preferences</button>
						</div>
					</div>
				</div>
				<div class="col-12 col-md-8 h-100 d-flex flex-column mt-1">
					<div class="card flex-grow mb-3">
						<div class="card-body">
							<h5 class="card-title">About</h5>
							<p class="card-text">{{ aboutMe }}</p>
						</div>
					</div>
					<div class="card friend-requests-card flex-grow mb-2">
						<div class="card-body">
							<h5 class="card-title">Friend Requests</h5>
							<div class="friend-requests-container" style="max-height: 400px; overflow: auto">
								<div v-for="(request, index) in friendRequests" :key="index" class="card mb-3">
									<div class="row g-0 align-items-center">
										<div class="col-4">
											<img :src="'http://localhost:5555/uploads/profilePictures/' + request.image" alt="Friend Request" class="img-fluid rounded-start" />
										</div>
										<div class="col-8">
											<div class="card-body">
												<h5 class="card-title">{{ request.name }}</h5>
												<p class="card-text">{{ request.description }}</p>
												<div class="d-flex justify-content-between align-items-center">
													<span class="badge bg-primary">{{ request.matchPercentage }}% Match</span>
													<div>
														<button class="btn btn-success btn-sm me-2" @click="acceptRequest(request)">Accept</button>
														<button class="btn btn-danger btn-sm" @click="ignoreRequest(request)">Ignore</button>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="row g-0 align-items-center" v-if="friendRequests.length === 0">No Friends</div>
							</div>
						</div>
					</div>
					<div class="card friends-card flex-grow mb-3">
						<div class="card-body">
							<h5 class="card-title">Friends</h5>
							<div class="list-group" style="max-height: 400px; overflow: auto">
								<button v-for="friend in friends" :key="friend.id" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
									<img :src="'http://localhost:5555/uploads/profilePictures/' + friend.user.profilePicture" alt="Friend Request" class="avatar" />
									{{ friend.user.username }}
									<div>
										<button class="btn btn-primary" @click="goToChat(friend.Chat.id)">Chat</button>
										<button class="btn btn-danger" @click="showRemoveFriendModal(friend)">Remove</button>
									</div>
								</button>
								<div class="list-group-item disabled" v-if="friends.length === 0">No Matched Roomie</div>
							</div>
						</div>
					</div>
				</div>
				<div v-if="removeFriendModal.show" class="modal">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title">Remove Friend</h5>
							<button type="button" class="close" @click="closeRemoveFriendModal">&times;</button>
						</div>
						<div class="modal-body">
							<p>Are you sure you want to remove {{ removeFriendModal.friend.user.username }} from your friends list?</p>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" @click="closeRemoveFriendModal">Cancel</button>
							<button type="button" class="btn btn-danger" @click="removeFriend">Remove</button>
						</div>
					</div>
				</div>

				<div class="overlay" v-show="isEditOverlayOpen">
					<div class="overlay-content">
						<h2>Edit Profile</h2>
						<form>
							<div class="form-group">
								<label for="userName">Username</label>
								<input type="text" class="form-control" id="userName" v-model="editedProfile.userName" />
							</div>
							<div class="form-group">
								<label for="aboutMe">About Me</label>
								<textarea class="form-control" id="aboutMe" rows="3" v-model="editedProfile.aboutMe"></textarea>
							</div>
							<div class="form-group">
								<label for="desc">Description</label>
								<textarea class="form-control" id="desc" rows="3" v-model="editedProfile.desc"></textarea>
							</div>
							<div class="form-group">
								<label for="photo1">Photo 1:</label>
								<input type="file" id="photo1" accept="image/*" @change="handlePhotoUpload(0, $event)" />
							</div>

							<div class="overlay-buttons">
								<button type="button" class="btn btn-secondary" @click="closeEditOverlay">Cancel</button>
								<button type="button" class="btn btn-primary" @click="saveProfileChanges">Save Changes</button>
							</div>
						</form>
					</div>
				</div>
			</div>
			<div class="modal" v-if="showPreferences">
				<div class="modal-dialog modal-dialog-scrollable modal-lg">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="preferencesModalLabel">Preferences</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" @click="showPreferencesBool"></button>
						</div>
						<div class="modal-body">
							<div class="container-fluid">
								<div class="row">
									<div class="col-md-6">
										<div class="mb-3">
											<label for="genderPreference" class="form-label">Gender Preference</label>
											<input type="text" class="form-control" id="genderPreference" v-model="preferences.genderPreference" readonly />
										</div>
										<div class="mb-3">
											<label for="bedtime" class="form-label">Bedtime</label>
											<input type="text" class="form-control" id="bedtime" v-model="preferences.bedtime" readonly />
										</div>
										<div class="mb-3">
											<label for="tidiness" class="form-label">Tidiness</label>
											<input type="text" class="form-control" id="tidiness" v-model="preferences.tidiness" readonly />
										</div>
										<div class="mb-3">
											<label for="smoking" class="form-label">Smoking</label>
											<input type="text" class="form-control" id="smoking" v-model="preferences.smoking" readonly />
										</div>
										<div class="mb-3">
											<label for="willingToLiveWithSmoker" class="form-label">Willing to Live with Smoker</label>
											<input type="text" class="form-control" id="willingToLiveWithSmoker" v-model="preferences.willingToLiveWithSmoker" readonly />
										</div>
									</div>
									<div class="col-md-6">
										<div class="mb-3">
											<label for="freeTime" class="form-label">Free Time</label>
											<input type="text" class="form-control" id="freeTime" v-model="preferences.freeTime" readonly />
										</div>
										<div class="mb-3">
											<label for="friendsVisit" class="form-label">Friends Visit</label>
											<input type="text" class="form-control" id="friendsVisit" v-model="preferences.friendsVisit" readonly />
										</div>
										<div class="mb-3">
											<label for="petsComfortable" class="form-label">Pets Comfortable</label>
											<input type="text" class="form-control" id="petsComfortable" v-model="preferences.petsComfortable" readonly />
										</div>
										<div class="mb-3">
											<label for="petPreferences" class="form-label">Pet Preferences</label>
											<textarea class="form-control" id="petPreferences" rows="3" v-model="preferences.petPreferences" readonly></textarea>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-6">
										<div class="mb-3">
											<label for="noiseLevel" class="form-label">Noise Level</label>
											<input type="text" class="form-control" id="noiseLevel" v-model="preferences.noiseLevel" readonly />
										</div>
										<div class="mb-3">
											<label for="cookingFrequency" class="form-label">Cooking Frequency</label>
											<input type="text" class="form-control" id="cookingFrequency" v-model="preferences.cookingFrequency" readonly />
										</div>
										<div class="mb-3">
											<label for="sharingBelongings" class="form-label">Sharing Belongings</label>
											<input type="text" class="form-control" id="sharingBelongings" v-model="preferences.sharingBelongings" readonly />
										</div>
									</div>
									<div class="col-md-6">
										<div class="mb-3">
											<label for="overnightGuests" class="form-label">Overnight Guests</label>
											<input type="text" class="form-control" id="overnightGuests" v-model="preferences.overnightGuests" readonly />
										</div>
										<div class="mb-3">
											<label for="cleaningDuties" class="form-label">Cleaning Duties</label>
											<input type="text" class="form-control" id="cleaningDuties" v-model="preferences.cleaningDuties" readonly />
										</div>
										<div class="mb-3">
											<label for="workSchedule" class="form-label">Work Schedule</label>
											<input type="text" class="form-control" id="workSchedule" v-model="preferences.workSchedule" readonly />
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-6">
										<div class="mb-3">
											<label for="spaceUsage" class="form-label">Space Usage</label>
											<input type="text" class="form-control" id="spaceUsage" v-model="preferences.spaceUsage" readonly />
										</div>
										<div class="mb-3">
											<label for="hobbies" class="form-label">Hobbies</label>
											<textarea class="form-control" id="hobbies" rows="3" v-model="preferences.hobbies" readonly></textarea>
										</div>
										<div class="mb-3">
											<label for="privacyExpectation" class="form-label">Privacy Expectation</label>
											<input type="text" class="form-control" id="privacyExpectation" v-model="preferences.privacyExpectation" readonly />
										</div>
									</div>
									<div class="col-md-6">
										<div class="mb-3">
											<label for="allergies" class="form-label">Allergies</label>
											<textarea class="form-control" id="allergies" rows="3" v-model="preferences.allergies" readonly></textarea>
										</div>
										<div class="mb-3">
											<label for="longTermPlans" class="form-label">Long-Term Plans</label>
											<input type="text" class="form-control" id="longTermPlans" v-model="preferences.longTermPlans" readonly />
										</div>
										<div class="mb-3">
											<label for="billSplit" class="form-label">Bill Split</label>
											<input type="text" class="form-control" id="billSplit" v-model="preferences.billSplit" readonly />
										</div>
										<div class="mb-3">
											<label for="conflictResolution" class="form-label">Conflict Resolution</label>
											<input type="text" class="form-control" id="conflictResolution" v-model="preferences.conflictResolution" readonly />
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal" @click="showPreferencesBool">Close</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script setup>
	import { ref, onMounted } from "vue";
	import { userStore } from "../stores/userStore";
	import { useRouter } from "vue-router";
	import { toast } from "vue3-toastify";
	import axios from "axios";
	const userInfo = userStore();
	const router = useRouter();
	const profileImgURL = ref("");
	const desc = ref("");
	const aboutMe = ref("");
	const friends = ref([]);
	const showPreferences = ref(false);
	const isEditOverlayOpen = ref(false);
	const editedProfile = ref({
		userName: "",
		desc: "",
		aboutMe: "",
	});
	const friendRequests = ref([]);
	const removeFriendModal = ref({
		show: false,
		friend: null,
	});
	const preferences = ref({
		genderPreference: "",
		bedtime: "",
		tidiness: "",
		smoking: "",
		willingToLiveWithSmoker: "",
		freeTime: "",
		friendsVisit: "",
		petsComfortable: "",
		petPreferences: "",
		noiseLevel: "",
		cookingFrequency: "",
		sharingBelongings: "",
		overnightGuests: "",
		cleaningDuties: "",
		workSchedule: "",
		spaceUsage: "",
		hobbies: "",
		privacyExpectation: "",
		allergies: "",
		longTermPlans: "",
		billSplit: "",
		conflictResolution: "",
	});

	const showRemoveFriendModal = (friend) => {
		removeFriendModal.value.show = true;
		removeFriendModal.value.friend = friend;
	};

	const closeRemoveFriendModal = () => {
		removeFriendModal.value.show = false;
		removeFriendModal.value.friend = null;
	};

	const removeFriend = async () => {
		try {
			console.log("Removing friend:", removeFriendModal.value.friend);
			const response = await axios
				.post("user/removeFriend", removeFriendModal.value.friend, {
					withCredentials: true,
				})
				.then(function (response) {
					toast.success(response.data.message, {
						position: toast.POSITION.BOTTOM_RIGHT,
						theme: "colored",
					});
					loadMyProfile();
					loadFriendRequests();
				});
		} catch (error) {
			console.error("Error saving profile changes:", error);
		}
		closeRemoveFriendModal();
	};
	onMounted(async () => {
		await loadMyProfile();
		await loadFriendRequests();
		await loadPreferences();
	});
	const goToChat = (friendId) => {
		router.push(`/chat/${friendId}`);
	};
	async function loadPreferences() {
		try {
			const response = await userInfo.loadPreferences();
			if (response.success && response.preferences) {
				Object.assign(preferences.value, response.preferences);
			}
		} catch (error) {
			console.error("Error loading preferences:", error);
		}
	}
	function showPreferencesBool() {
		let showPreferencesboolen = showPreferences.value;
		showPreferences.value = !showPreferencesboolen;
	}
	function editProfile() {
		editedProfile.value.userName = userInfo.userName;
		editedProfile.value.desc = desc.value;
		editedProfile.value.aboutMe = aboutMe.value;
		editedProfile.value.photos = ["../assets/img/photo1.jpg", "../assets/img/photo2.jpg", "../assets/img/photo3.jpg"];
		openEditOverlay();
	}

	function openEditOverlay() {
		isEditOverlayOpen.value = true;
	}

	function closeEditOverlay() {
		isEditOverlayOpen.value = false;
	}

	async function saveProfileChanges() {
		const formData = new FormData();
		formData.append("userName", editedProfile.value.userName);
		formData.append("aboutMe", editedProfile.value.aboutMe);
		formData.append("desc", editedProfile.value.desc);
		formData.append("photo", editedProfile.value.photos[0]);
		try {
			const response = await axios
				.post("user/editProfile", formData, {
					headers: {
						"Content-Type": "multipart/form-data",
					},
					withCredentials: true,
				})
				.then(function (response) {
					toast.success(response.data.message, {
						position: toast.POSITION.BOTTOM_RIGHT,
						theme: "colored",
					});

					closeEditOverlay();
					loadMyProfile();
					loadFriendRequests();
				})
				.catch(function (error) {
					toast.error(error.response.data.errorMessage, {
						position: toast.POSITION.BOTTOM_RIGHT,
						theme: "colored",
					});
				});
		} catch (error) {
			console.error("Error saving profile changes:", error);
		}
	}

	function handlePhotoUpload(index, event) {
		const file = event.target.files[0];
		editedProfile.value.photos.splice(index, 1, file);
	}

	const acceptRequest = async (request) => {
		try {
			const response = await axios
				.post("user/acceptMatchRequest", request, {
					withCredentials: true,
				})
				.then(function (response) {
					toast.success(response.data.message, {
						position: toast.POSITION.BOTTOM_RIGHT,
						theme: "colored",
					});
					loadMyProfile();
					loadFriendRequests();
				});
		} catch (error) {
			console.error("Error saving profile changes:", error);
		}
	};

	const ignoreRequest = async (request) => {
		try {
			const response = await axios
				.post("user/rejectMatchRequest", request, {
					withCredentials: true,
				})
				.then(function (response) {
					toast.success(response.data.message, {
						position: toast.POSITION.BOTTOM_RIGHT,
						theme: "colored",
					});
					loadMyProfile();
					loadFriendRequests();
				});
		} catch (error) {
			console.error("Error saving profile changes:", error);
		}
	};
	function handleStatus401(response) {
		const userInfo = userStore();
		userInfo.logOutUser();
		router.push("/");
	}
	async function loadMyProfile() {
		await axios
			.get("/user/myprofile/" + userInfo.userId, { withCredentials: true })
			.then((response) => {
				const user = response.data.user;
				desc.value = user.desc;
				aboutMe.value = user.aboutMe;
				friends.value = response.data.chats;
				userInfo.profilePicture = user.profilePicture;
				//	console.log(friends.value);
			})
			.catch(function (error) {
				if (error.response && error.response.status === 401) {
					handleStatus401(error);
				}
			});
		profileImgURL.value = `http://localhost:5555/uploads/profilePictures/` + userInfo.profilePicture;
	}

	async function loadFriendRequests() {
		await axios
			.get("/user/getMatchRequests", { withCredentials: true })
			.then((response) => {
				friendRequests.value = response.data.matching;
			})
			.catch(function (error) {
				if (error.response && error.response.status === 401) {
					handleStatus401(error);
				}
			});
	}
</script>

<style scoped>
	.page-container {
		margin-top: 4.7rem;
		height: 90vh;
	}

	.container-fluid {
		background-color: rgba(213, 169, 248, 0.233);
	}

	.friend-requests-card,
	.friends-card {
		margin-top: 1rem;
	}

	.overlay {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background-color: rgba(0, 0, 0, 0.5);
		display: flex;
		align-items: center;
		justify-content: center;
		z-index: 999;
	}

	.overlay-content {
		background-color: #fff;
		padding: 20px;
		max-width: 500px;
		width: 100%;
	}

	.overlay-buttons {
		display: flex;
		justify-content: flex-end;
		margin-top: 20px;
	}

	.avatar {
		vertical-align: middle;
		width: 50px;
		height: 50px;
		border-radius: 50%;
	}

	@media (max-width: 767px) {
		.page-container {
			margin-top: 3.5rem;
			height: auto;
		}

		.container-fluid {
			padding: 0 1rem;
		}

		.col-12 {
			padding: 0;
		}

		.card {
			border-radius: 0;
			margin-top: 0.5rem;
			margin-bottom: 0.5rem;
		}

		.friend-requests-card,
		.friends-card {
			margin-top: 0.5rem;
		}

		.overlay-content {
			max-width: 90%;
		}
	}

	.modal {
		display: block;
		position: fixed;
		z-index: 1;
		left: 0;
		top: 0;
		width: 100%;
		height: 100%;
		overflow: auto;
		background-color: rgba(0, 0, 0, 0.4);
	}

	.modal-content {
		background-color: #fefefe;
		margin: 15% auto;
		padding: 20px;
		border: 1px solid #888;
		width: 80%;
	}
	textarea[readonly="readonly"],
	textarea[readonly] {
		background-color: rgb(245, 245, 245);
	}

	input[readonly="readonly"],
	input[readonly] {
		background-color: rgb(245, 245, 245);
	}
</style>
