/**
 * @fileOverview This file has functions related to admin user add view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Admin user add View
 * @class AdminUserAddView
 * @constructor
 * @extends Backbone.View
 */
App.AdminUserAddView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/admin_user_add'],
    tagName: 'article',
    className: 'clearfix',
    id: 'admin-user-add',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#AdminUserAddForm': 'adminUserAdd',
        'blur #inputemail': 'prefillUserdetails'
    },
    /**
     * adminUserAdd()
     * save user
     * @return false
     */
    adminUserAdd: function(e) {
        var target = $(e.target);
        var data = target.serializeObject();
        data.is_send_newsletter = parseInt(data.is_send_newsletter);
        data.is_productivity_beats = true;
        var self = this;
        var user = new App.User();
        user.url = api_url + 'users.json';
        user.save(data, {
            success: function(model, response) {
                if (response.error) {
                    if (response.error === 1) {
                        self.flash('danger', i18next.t('Email address already exist. Your registration process is not completed. Please, try again.'));
                    } else if (response.error === 2) {
                        self.flash('danger', i18next.t('Username already exists. Your registration process is not completed. Please, try again.'));
                    }
                    $('#inputPassword').val('');
                } else {
                    self.flash('success', i18next.t('User added successfully.'));
                    target[0].reset();
                    app.navigate('#/users', {
                        trigger: true,
                        replace: true
                    });
                }
            }
        });
        return false;
    },
    /**
     * prefillUserdetails()
     * prefill user details from given email
     * @return false
     */
    prefillUserdetails: function(e) {
        var email = $('#inputemail').val();
        if (!_.isEmpty(email) && new RegExp('[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$').test(email)) {
            var name;
            var full_name;
            var user_initial;
            if (email) {
                var index = email.lastIndexOf("@");
                email = email.substr(0, index);
                // replace non-text
                name = email.replace('/[\W\d_]+/', ' ');
                // capitalize first letter in every word
                name = name.toLowerCase().replace(/\b[a-z]/g, function(letter) {
                    return letter.toUpperCase();
                });
                // remove white space
                name = name.trim();
                // check for spces between words
                var matches = name.match(/(.*)?\s(.*)$/);
                if (matches) {
                    full_name = matches[1] + ' ' + matches[2];
                } else {
                    full_name = name;
                }
                $('#inputFullName').val(full_name);
                user_initial = name.substr(0, 1).toUpperCase();
                $('#inputinitials').val(user_initial);
                $('#inputusername').focus();
            }
        }
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            timezones: this.model.timezones
        }));
        $('.js-admin-user-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-setting-menu, .js-admin-email-menu, .js-admin-role-menu, .js-admin-board-menu').removeClass('active');
        this.showTooltip();
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
            }).select2('val', '');
        }).defer();
        return this;
    }
});
