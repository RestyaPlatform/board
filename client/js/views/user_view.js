/**
 * @fileOverview This file has functions related to user view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * User View
 * @class UserView
 * @constructor
 * @extends Backbone.View
 */
App.UserView = Backbone.View.extend({
    template: JST['templates/user_view'],
    tagName: 'div',
    className: '',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form.js-user-profile-edit': 'userProfileEdit',
        'click .js-user-cards': 'userCards',
        'click #js-user-activites-load-more': 'loadActivities',
        'click .js-remove-image': 'removeImage',
        'click .js-use-uploaded-avatar': 'computerOpenUserProfile',
        'change #js-user-profile-attachment': 'addUserProfile',

    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        var last_activity_id = 0;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.type = 'profile';
        if (!_.isUndefined(options.type)) {
            this.type = options.type;
        }
        this.model.bind('change', this.render, this);
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        if (!_.isUndefined(this.type) && (this.type == 'cards' || this.type == 'settings')) {
            this.renderType();
        } else {
            var self = this;
            changeTitle('User - ' + _.escape(this.model.attributes.username));
            var activities = new App.ActivityCollection();
            activities.url = api_url + 'users/' + self.model.id + '/activities.json?&type=profile';
            activities.fetch({
                cache: false,
                success: function(user, response) {
                    self.$el.html(self.template({
                        user: self.model,
                        type: self.type
                    }));
                    if (!_.isEmpty(activities.models)) {
                        var last_activity = _.min(activities.models, function(activity) {
                            return activity.id;
                        });
                        last_activity_id = last_activity.id;
                        $('#js-user-activites-load-more').removeClass('hide');
                        for (var i = 0; i < activities.models.length; i++) {
                            var activity = activities.models[i];
                            self.$('#js-user-activites').append(new App.UserActivityView({
                                model: activity,
                                type: self.type
                            }).el).find('.timeago').timeago();
                        }
                    } else {
                        $('#js-user-activites-load-more').addClass('hide');
                        self.$('#js-user-activites').append(new App.UserActivityView({
                            model: null,
                            type: self.type
                        }).el);
                    }
                }
            });
            this.showTooltip();
            return this;
        }
    },
    /**
     * renderCards()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    renderType: function() {
        this.$el.html(this.template({
            user: this.model,
            type: this.type
        }));
        if (this.type == 'cards') {
            this.userCards();
        } else {
            var _this = this;
            _(function() {
                Backbone.TemplateManager.baseUrl = '{name}';
                var uploadManager = new Backbone.UploadManager({
                    uploadUrl: api_url + 'users/' + _this.model.id + '.json?token=' + api_token,
                    autoUpload: true,
                    dropZone: $('#dropzone'),
                    singleFileUploads: true,
                    formData: $('form.js-user-profile-edit').serialize(),
                    fileUploadHTML: '<input id="fileupload1" type="file" name="attachment"  >',
                });
                uploadManager.on('fileadd', function(file) {
                    $('#dropzone-cssloader').addClass('cssloader');
                });
                uploadManager.on('filedone', function(file, data) {
                    if (!_.isUndefined(data.result.profile_picture_path)) {
                        $('#dropzone-cssloader').removeClass('cssloader');
                        _this.model.set('profile_picture_path', data.result.profile_picture_path);
                        var Auth = JSON.parse(window.sessionStorage.getItem('auth'));
                        Auth.user.profile_picture_path = data.result.profile_picture_path + "?uid=" + Math.floor((Math.random() * 9999) + 1);
                        window.sessionStorage.setItem('auth', JSON.stringify(Auth));
                        this.footerView = new App.FooterView({
                            model: Auth,
                        }).render();
                        $('#footer').html(this.footerView.el);
                        _this.render();
                    }
                });
                uploadManager.renderTo($('#manager-area'));
            }).defer();
        }
    },
    /**
     * userBoardList()
     * delete user
     * @return false
     */
    deleteUser: function() {
        this.model.destroy();
        this.model.url = api_url + 'users/' + this.model.id + '.json';
        this.$el.remove();
        return false;
    },
    /**
     * userProfileEdit()
     * update user profile
     * @param e
     * @type Object(DOM event)
     */
    userProfileEdit: function(e) {
        e.preventDefault();
        var self = this;
        var form = $(e.target);
        var fileData = new FormData(form[0]);
        var data = $(e.target).serializeObject();
        this.model.set(data);
        this.render();
        this.model.url = api_url + 'users/' + this.model.id + '.json';
        this.model.save(fileData, {
            patch: true,
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            error: function(e, s) {
                self.flash('danger', 'Unable to update. Please try again.');
            },
            success: function(model, response) {
                if (!_.isEmpty(response.success)) {
                    self.flash('success', response.success);
                } else if (!_.isEmpty(response.error)) {
                    self.flash('danger', response.error);
                } else {
                    self.flash('danger', 'User Profile could not be updated. Please, try again.');
                }
                if (!_.isUndefined(response.profile_picture_path)) {
                    self.model.set('profile_picture_path', self.showImage('User', user.attributes.id, 'small_thumb'));
                    this.footerView = new App.FooterView({
                        model: authuser,
                    }).render();
                    $('#footer').html(this.footerView.el);
                } else {
                    self.model.set('profile_picture_path', null);
                    self.model.set('initials', $('#inputinitials').val());
                    $('.js-user-img').html('<i class="avatar avatar-color-194 avatar-sm">' + $('#inputinitials').val() + '</i>');
                }
            }
        });
    },
    /**
     * userCards()
     * display user cards
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    userCards: function() {
        var self = this;
        self.model.cards.url = api_url + 'users/' + self.model.id + '/cards.json?';
        self.model.cards.fetch({
            cache: false,
            success: function(card, response) {
                self.$('#cards').html('');
                var card_users = new App.CardUserCollection();
                card_users = self.model.cards.groupBy(function(model) {
                    return [model.get('board_name')];
                });
                if (!_.isEmpty(card_users)) {
                    _.map(card_users, function(card_user, key) {
                        self.$('#cards').append(new App.UserCardsView({
                            key: key,
                            model: card_user
                        }).el);
                    });
                } else {
                    self.$('#cards').html('No cards available.');
                }
                $('#tab-loaded-content').load();
            }
        });
    },
    /**
     * loadActivities()
     * display load Activities
     */
    loadActivities: function() {
        var self = this;
        var activities = new App.ActivityCollection();
        var query_string = '?last_activity_id=' + last_activity_id + '&type=' + self.type;
        activities.url = api_url + 'users/' + self.model.id + '/activities.json' + query_string;
        activities.fetch({
            cache: false,
            success: function(user, response) {
                if (!_.isEmpty(activities) && !_.isEmpty(activities.models)) {
                    for (var i = 0; i < activities.models.length; i++) {
                        var activity = activities.models[i];
                        self.$('#js-user-activites').append(new App.UserActivityView({
                            model: activity
                        }).el).find('.timeago').timeago();
                    }
                    var last_activity = _.min(activities.models, function(activity) {
                        return activity.id;
                    });
                    last_activity_id = last_activity.id;
                } else {
                    self.$('#js-user-activites-load-more').removeClass();
                }
            }
        });
    },
    /**
     * removeImage()
     * remive image
     * @param e
     * @type Object(DOM event)
     */
    removeImage: function(e) {
        e.preventDefault();
        this.model.set('profile_picture_path', null);
        this.render();
        this.model.url = api_url + 'users/' + this.model.id + '.json';
        this.model.set('initials', $('#inputinitials').val());
        $('.js-user-img').html('<i class="avatar avatar-color-194 avatar-sm">' + $('#inputinitials').val() + '</i>');
        this.model.save({
            profile_picture_path: 'NULL'
        }, {
            patch: true
        });
        return false;
    },
    /**
     * computerOpenUserProfile()
     * trigger file upload
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    computerOpenUserProfile: function(e) {
        e.preventDefault();
        var fileLi = $(e.target);
        $('#js-user-profile-attachment').remove();
        var form = $('#js-user-profile-edit');
        $(form).append('<input class="hide" type="file" name="attachment" id="js-user-profile-attachment">');
        $('#js-user-profile-attachment', form).trigger('click');
        return false;
    },
    /**
     * addUserProfile()
     * add card attachment
     * @param e
     * @type Object(DOM event)
     */
    addUserProfile: function(e) {
        e.preventDefault();
        var self = this;
        $('#dropzone-cssloader').addClass('cssloader');
        var form = $('#js-user-profile-edit');
        var target = $(e.target);
        var fileData = new FormData(form[0]);
        this.model.url = api_url + 'users/' + this.model.id + '.json';
        this.model.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            success: function(model, response) {
                $('#dropzone-cssloader').removeClass('cssloader');
                self.model.set('profile_picture_path', response.profile_picture_path);
                var Auth = JSON.parse(window.sessionStorage.getItem('auth'));
                Auth.user.profile_picture_path = response.profile_picture_path + "?uid=" + Math.floor((Math.random() * 9999) + 1);
                window.sessionStorage.setItem('auth', JSON.stringify(Auth));
                this.footerView = new App.FooterView({
                    model: Auth,
                }).render();
                $('#footer').html(this.footerView.el);
                self.render();
            }
        });
    }
});
