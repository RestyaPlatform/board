/**
 * @fileOverview This file has functions related to user view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
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
        $('.action-close', $('.dockmodal.active')).trigger('click');
        var last_activity_id = 0;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.type = 'profile';
        this.page = options.page;
        if (!_.isUndefined(options.type)) {
            this.type = options.type;
        }
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
        if (!_.isUndefined(this.type) && (this.type == 'cards' || this.type == 'settings' || this.type == 'oauth_applications')) {
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
                        type: self.type,
                        page: self.page,
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
        var is_send_newsletter_val = this.model.attributes.is_send_newsletter;
        this.$el.html(this.template({
            user: this.model,
            type: this.type,
            page: this.page
        }));
        if (this.type == 'cards') {
            this.userCards();
        } else if (this.type == 'oauth_applications') {
            this.oauthApplications();
        } else {
            var _this = this;
            _(function() {
                $('#is_send_newsletter').select2({
                    formatResult: function(repo) {
                        var split = repo.text.split(',');
                        markup = '<div class="clearfix"><span class="show">' + split[0] + '</span><span class="show small">' + split[1] + '</span></div>';
                        return markup;
                    },
                    formatSelection: function(repo) {
                        var split = repo.text.split(',');
                        return split[0];
                    },
                }).select2('val', is_send_newsletter_val);
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
                        authuser = Auth;
                        var hash = calcMD5(SecuritySalt + 'User' + _this.model.id + 'png' + 'small_thumb');
                        var profile_picture_path = window.location.pathname + 'img/small_thumb/User/' + _this.model.id + '.' + hash + '.png';
                        $('.js-use-uploaded-avatar').html('<img src="' + profile_picture_path + '" width="50" height="50" class="js-user-avatar">');
                        this.footerView = new App.FooterView({
                            model: Auth,
                        }).render();
                        $('#footer').html(this.footerView.el);
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
                self.flash('danger', i18next.t('Unable to update. Please try again.'));
            },
            success: function(model, response) {
                if (!_.isEmpty(response.success)) {
                    self.flash('success', i18next.t('User Profile has been updated.'));
                } else if (response.error) {
                    if (response.error === 1) {
                        self.flash('danger', i18next.t('File extension not supported. It supports only jpg, png, bmp and gif.'));
                    } else if (response.error === 2) {
                        self.flash('danger', i18next.t('Email address already exist. User Profile could not be updated. Please, try again.'));
                    }
                } else {
                    self.flash('danger', i18next.t('User Profile could not be updated. Please, try again.'));
                }
                if (!_.isUndefined(response.activity.profile_picture_path) && response.activity.profile_picture_path !== null) {
                    self.model.set('profile_picture_path', response.activity.profile_picture_path);
                    var Auth = JSON.parse(window.sessionStorage.getItem('auth'));
                    Auth.user.profile_picture_path = response.activity.profile_picture_path;
                    window.sessionStorage.setItem('auth', JSON.stringify(Auth));
                    authuser = Auth;
                    this.footerView = new App.FooterView({
                        model: Auth,
                    }).render();
                    $('#footer').html(this.footerView.el);
                } else {
                    self.model.set('profile_picture_path', null);
                    self.model.set('initials', $('#inputinitials').val());
                    self.model.set('is_send_newsletter', data.is_send_newsletter);
                    $('.js-user-img').html('<i class="avatar avatar-color-194 avatar-sm">' + $('#inputinitials').val() + '</i>');
                }
            }
        });
    },
    /**
     * oauthApplications()
     * display connected applications
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    oauthApplications: function() {
        var self = this;
        var oauth_applications = new App.OauthApplicationCollection();
        oauth_applications.url = api_url + 'oauth/applications.json';
        oauth_applications.fetch({
            cache: false,
            success: function(model, response) {
                if (!_.isEmpty(response)) {
                    self.$('#oauth_applications').append(new App.OauthApplicationsView({
                        model: response
                    }).el);
                }
                $('#tab-loaded-content').load();
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
                    self.$('#cards').html('<span class="alert alert-info col-xs-12">' + i18next.t('No %s available.', {
                        postProcess: 'sprintf',
                        sprintf: [i18next.t('cards')]
                    }) + '</span>');
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
                    self.$('#js-user-activites-load-more').remove();
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
        this.model.url = api_url + 'users/' + this.model.id + '.json';
        this.model.set('initials', $('#inputinitials').val());
        this.model.set('is_send_newsletter', this.model.attributes.is_send_newsletter);
        $('.js-user-img').html('<i class="avatar avatar-color-194 avatar-sm">' + $('#inputinitials').val() + '</i>');
        this.model.save({
            profile_picture_path: 'NULL'
        }, {
            patch: true
        });
        this.model.set('profile_picture_path', null);
        $('.js-use-uploaded-avatar').html('<i class="avatar avatar-color-194 avatar-md img-rounded">' + $('#inputinitials').val() + '</i>');
        var Auth = JSON.parse(window.sessionStorage.getItem('auth'));
        Auth.user.profile_picture_path = null;
        window.sessionStorage.setItem('auth', JSON.stringify(Auth));
        authuser = Auth;
        this.footerView = new App.FooterView({
            model: Auth,
        }).render();
        $('#footer').html(this.footerView.el);
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
        var ext = $('#js-user-profile-attachment').val().split('.').pop().toLowerCase();
        if ($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1) {
            self.flash('danger', i18next.t('File extension not supported. It supports only jpg, png, bmp and gif.'));
            $('#dropzone-cssloader').removeClass('cssloader');
            return false;
        } else {
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
                    if (response.error) {
                        if (response.error === 1) {
                            self.flash('danger', i18next.t('File extension not supported. It supports only jpg, png, bmp and gif.'));
                        } else if (response.error === 2) {
                            self.flash('danger', i18next.t('Email address already exist. User Profile could not be updated. Please, try again.'));
                        }
                    }
                    self.model.set('profile_picture_path', response.profile_picture_path);
                    var Auth = JSON.parse(window.sessionStorage.getItem('auth'));
                    Auth.user.profile_picture_path = response.profile_picture_path + "?uid=" + Math.floor((Math.random() * 9999) + 1);
                    window.sessionStorage.setItem('auth', JSON.stringify(Auth));
                    authuser = Auth;
                    var hash = calcMD5(SecuritySalt + 'User' + self.model.id + 'png' + 'small_thumb');
                    var profile_picture_path = window.location.pathname + 'img/small_thumb/User/' + self.model.id + '.' + hash + '.png?uid=' + Math.floor((Math.random() * 9999) + 1);
                    $('.js-use-uploaded-avatar').html('<span class="js-remove-image  profile-block show"><i class="icon icon-remove close-block cur h6"></i></span><img src="' + profile_picture_path + '" width="50" height="50" class="js-user-avatar">');
                    this.footerView = new App.FooterView({
                        model: Auth,
                    }).render();
                    $('#footer').html(this.footerView.el);
                }
            });
        }
    }
});
