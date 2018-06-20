from setuptools import setup


setup(
    name='url_match',
    version='0.1',
    packages=['url_match'],
    author='MelomanCool',
    author_email='melomancool@gmail.com',
    url='https://github.com/MelomanCool/url-match',
    install_requires=[
        'lark-parser==0.5.6',
        'hy==0.14.0',
        'furl==1.0.1'
    ],
    package_data={'url_match': ['*.hy', '*.g']},
)
